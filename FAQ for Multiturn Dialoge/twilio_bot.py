from jaseci.actions.live_actions import jaseci_action  # step 1
from twilio.rest import Client

account_sid = 'ACc36e6423c66202ccdc767d631d226c79' 
auth_token = '43939f69b0aaffa38b76094005ca94b0'
client = Client(account_sid, auth_token) 
#4fQ3SNLswhjPy6wj6pBODH6oOOgAtZro

@jaseci_action(act_group=["twilio"], allow_remote=True)
def twilio_bot(message, phone_number):

    messagess = client.messages.create( 
                                from_='whatsapp:+14155238886',  
                                body=message,
                                to=phone_number
                            ) 
    return messagess

if __name__ == "__main__":
    from jaseci.actions.remote_actions import launch_server
    launch_server(port=80005)

    



