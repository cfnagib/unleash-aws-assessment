import boto3
import requests
import json

# --- البيانات المحدثة بناءً على آخر Apply ---
REGION = "us-east-1"
CLIENT_ID = "29d912tvs6sn2o9t4t0qkun57n"
USER_EMAIL = "cfnagib@outlook.de"
PASSWORD = "Christian2026!" # كلمة المرور الجديدة اللي فعلناها

# الروابط الجديدة من الـ Output الأخير
API_EAST = "https://zdu7uz98z4.execute-api.us-east-1.amazonaws.com"
API_LONDON = "https://jus755waw3.execute-api.eu-west-1.amazonaws.com"

def get_jwt_token():
    print("--- 1. Authenticating with Cognito ---")
    client = boto3.client('cognito-idp', region_name=REGION)
    try:
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
    
    # اختبار الروابط - في اللحظة دي الـ Lambda هتبعت الـ SNS للشركة
    for name, url in [("US-EAST (Virginia)", API_EAST), ("EU-WEST (London)", API_LONDON)]:
        try:
            r = requests.get(f"{url}/secure-greet", headers=headers)
            print(f"Region {name}: Status {r.status_code}")
            print(f"Response Content: {r.text}\n")
        except Exception as e:
            print(f"❌ Error testing {name}: {e}")

if __name__ == "__main__":
    id_token = get_jwt_token()
    if id_token:
        test_endpoints(id_token)
        
        final_payload = {
            "candidate": USER_EMAIL,
            "github_repo": "https://github.com/cfnagib/unleash-aws-assessment",
            "status": "Infrastructure Validated"
        }
        print("--- Final SNS Payload Sent via Lambda ---")
        print(json.dumps(final_payload, indent=4))