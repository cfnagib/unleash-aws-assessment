exports.handler = async (event) => {
    return {
        statusCode: 200,
        body: JSON.stringify({
            message: "Hello from Unleash Live Assessment!",
            region: process.env.AWS_REGION
        }),
    };
};
