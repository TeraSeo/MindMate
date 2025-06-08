const {onRequest} = require("firebase-functions/v2/https");
const {Configuration, OpenAIApi} = require("openai");
const admin = require("firebase-admin");
require("dotenv").config();

admin.initializeApp(); // Firebase Admin 초기화

exports.generateGptResponse = onRequest(async (req, res) => {
  // 1. Authorization 헤더에서 토큰 추출
  const authHeader = req.headers.authorization || "";
  const token = authHeader.startsWith("Bearer ")?authHeader.split(" ")[1]:null;

  if (!token) {
    return res.status(401).send({error: "Missing auth token"});
  }

  try {
    // 2. 토큰 검증
    const decoded = await admin.auth().verifyIdToken(token);
    console.log("✅ Authenticated UID:", decoded.uid);

    // 3. OpenAI 키 설정
    const openaiKey = process.env.OPENAI_API_KEY;
    const openaiOrg = process.env.OPENAI_ORG;

    const {personality, relationship, chattingStyle, gender, ageGroup,
      replyLanguage, userMessage, conversationSummary,
      username, userMessages} = req.body;

    const configuration = new Configuration({
      apiKey: openaiKey,
      organization: openaiOrg,
    });

    const openai = new OpenAIApi(configuration);

    // 4. 프롬프트 구성 및 GPT 호출
    const prompt = `
      You are an emotional, human-like AI character chatbot.
      Your job is to respond naturally and emotionally, 
      like a real person, based on the user's message and context.
      
      ### Conversation Instructions:
      - Respond in ${replyLanguage}
      - Match emotional tone and length of the latest message
      - Respond with exactly ${userMessage.split("\\n").length + 1} lines
      - End each sentence with a newline (\\n)
      - Do not include prefixes like "AI:" or "Friend reply:"
      - Speak like this character: ${personality}, ${ageGroup}, ${gender}, 
      talking to their ${relationship}
      
      ### Conversation Context:
      - Username: ${username}
      - Chatting Style: ${chattingStyle}
      - Last Conversation Summary: ${conversationSummary}
      
      ### User Messages:
      ${userMessages}
      
      ### Your Task:
      Reply to the most recent user message appropriately.
      Understand the nuance and tone, and provide a relevant emotional response.
    `;


    const estimatedReplyLength = Math.min(1000,
        Math.max(200, userMessage.length * 2));
    const response = await openai.createChatCompletion({
      model: "gpt-4o",
      messages: [
        {role: "user", content: prompt},
      ],
      temperature: 0.8,
      max_tokens: estimatedReplyLength,
    });

    const reply = response.data.choices[0].message.content.trim();
    return res.status(200).send({reply});
  } catch (err) {
    console.error("❌ Authentication or GPT error:", err);
    return res.status(401).send({error: "Unauthorized"});
  }
});
