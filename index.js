const { SNSClient, PublishCommand } = require("@aws-sdk/client-sns");
const sns = new SNSClient({});

exports.handler = async (event) => {
    const region = process.env.AWS_REGION;
    
    // البيانات اللي الشركة مستنياها في نظامهم
    const payload = {
        email: "cfnagib@outlook.de", 
        source: "Lambda",
        region: region,
        repo: "https://github.com/cfnagib/unleash-aws-assessment"
    };

    try {
        const command = new PublishCommand({
            // ده العنوان (ARN) اللي الشركة كاتباه في ملف الـ PDF
            TopicArn: "arn:aws:sns:us-east-1:637226132752:Candidate-Verification-Topic", 
            Message: JSON.stringify(payload)
        });
        await sns.send(command);
        
        return {
            statusCode: 200,
            body: JSON.stringify({ message: "Verification sent to Unleash Live!", region: region })
        };
    } catch (err) {
        console.error(err);
        return { statusCode: 500, body: JSON.stringify({ error: "Failed to send SNS", details: err.message }) };
    }
};