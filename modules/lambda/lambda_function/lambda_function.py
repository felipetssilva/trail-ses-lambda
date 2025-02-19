import json
import boto3
import os

def lambda_handler(event, context):
    print("EC2 state change event:", json.dumps(event, indent=2))

    instance_id = event['detail']['instance-id']
    state = event['detail']['state']

    message = f"""
    EC2 Instance State Change Notification
    Instance ID: {instance_id}
    New State: {state}
    Time: {event['time']}
    Region: {event['region']}
    """

    ses = boto3.client('ses', region_name='us-east-1')

    params = {
        'Destination': {
            'ToAddresses': [os.environ['SOURCE_EMAIL']]
        },
        'Message': {
            'Body': {
                'Text': {
                    'Data': message
                }
            },
            'Subject': {
                'Data': f'EC2 Instance {instance_id} is now {state}'
            }
        },
        'Source': os.environ['SOURCE_EMAIL']
    }

    try:
        result = ses.send_email(**params)
        print("Email sent successfully:", result)
        return {
            'statusCode': 200,
            'body': 'Email sent successfully'
        }
    except Exception as error:
        print("Error sending email:", str(error))
        raise error