import boto3
import requests
import json

# --- بيانات الوصول الخاصة بك (مستخرجة من الأوامر السابقة) ---
REGION = "us-east-1"
CLIENT_ID = "735og9b6uobphrbfcnqnuoj697"
USER_EMAIL = "cfnagib@outlook.de"
PASSWORD = "UnleashPass123!" # كلمة المرور التي وضعناها في كود الـ Terraform

# الروابط التي ظهرت لك في المخرجات (Outputs)
API_EAST = "https://hmhjzi1c0e.execute-api.us-east-1.amazonaws.com"
API_LONDON = "https://0t19qg7q9c.execute-api.eu-west-1.amazonaws.com"

def get_jwt_token():
    print("--- 1. Authenticating with Cognito ---")
    client = boto3.client('cognito-idp', region_name=REGION)
    try:
        # عملية تسجيل الدخول لجلب الـ Token
        response = client.initiate_auth(
            ClientId=CLIENT_ID,
            AuthFlow='USER_PASSWORD_AUTH',
            AuthParameters={
                'USERNAME': USER_EMAIL,
                'PASSWORD': PASSWORD
            }
        )
        print("✅ Successfully authenticated!")
        return response['AuthenticationResult']['IdToken']
    except Exception as e:
        print(f"❌ Auth Error: {e}")
        return None

def test_endpoints(token):
    print("\n--- 2. Testing Regional Endpoints ---")
    headers = {'Authorization': token}
    
    # سنقوم بتجربة الرابط في المنطقتين
    for name, url in [("US-EAST (Virginia)", API_EAST), ("EU-WEST (London)", API_LONDON)]:
        try:
            # نرسل طلب GET للمسار الذي برمجناه
            r = requests.get(f"{url}/secure-greet", headers=headers)
            print(f"Region {name}: Status {r.status_code}")
            print(f"Response Content: {r.text}\n")
        except Exception as e:
            print(f"❌ Error testing {name}: {e}")

if __name__ == "__main__":
    # تشغيل السلسلة: تسجيل دخول -> ثم اختبار الروابط
    id_token = get_jwt_token()
    if id_token:
        test_endpoints(id_token)
        
        # هذا هو الشكل النهائي للبيانات (Payload) المطلوب إرساله
        final_payload = {
            "candidate": USER_EMAIL,
            "github_repo": "https://github.com/cfnagib/unleash-aws-assessment",
            "status": "Infrastructure Validated"
        }
        print("--- Final SNS Payload Ready ---")
        print(json.dumps(final_payload, indent=4))