edge trans_intent{
    has intent;
}

node faq_root{
    has questions;
    has answers;
    can use.qa_classify, twilio.twilio_bot;
    
    can classify_intent{
        data = file.load_json("faq.json");
        intent_classes = [];
        if(!visitor.utterance){
            visitor.answer = "I can answer an array of Questions about Recruiter Platform. What can I help you with?";
            twilio.twilio_bot(visitor.answer, visitor.phone_number);
        }else{    
            for i in data{
                intent_classes.list::append(i["Question"]);
            }
            best_answer  = use.qa_classify(
                text = visitor.utterance,
                classes = intent_classes
            );
            visitor.user_ctx["intent"] = best_answer["match"];
        }
    }
    can process{
        if(!visitor.utterance && visitor.user_ctx["last_node"]){
            visitor.answer = "Do you have any other questions?";
            twilio.twilio_bot(visitor.answer, visitor.phone_number);
        }
    }
    can nlg{}
}
node state:faq_root{
    can process{
        visitor.user_ctx["last_node"] = here;
        visitor.user_ctx["next_node"] = net.root();
    }
    can nlg{
        visitor.answer = here.answers;
        twilio.twilio_bot(visitor.answer, visitor.phone_number);
    }
}