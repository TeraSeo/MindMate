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
      replyLanguage, userMessage, conversationSummary} = req.body;

    const configuration = new Configuration({
      apiKey: openaiKey,
      organization: openaiOrg,
    });

    const openai = new OpenAIApi(configuration);

    // 4. 프롬프트 구성 및 GPT 호출
    const prompt = `
Generate reply message.
End each sentence with a line break (\\n).
No prefix like "Friend Reply:".
Personality: ${personality || "None"}
Relationship: ${relationship || "None"}
Chatting Style: ${chattingStyle || "None"}
Gender: ${gender || "None"}
Age Group: ${ageGroup || "None"}
Reply Language: ${replyLanguage || "None"}
Conversation Summary: ${conversationSummary || "None"}
User Message: ${userMessage || "None"}
`;


    const response = await openai.createChatCompletion({
      model: "gpt-3.5-turbo",
      messages: [
        {role: "user", content: prompt},
      ],
      temperature: 0.8,
      max_tokens: userMessage.length,
    });

    const reply = response.data.choices[0].message.content.trim();
    return res.status(200).send({reply});
  } catch (err) {
    console.error("❌ Authentication or GPT error:", err);
    return res.status(401).send({error: "Unauthorized"});
  }
});
