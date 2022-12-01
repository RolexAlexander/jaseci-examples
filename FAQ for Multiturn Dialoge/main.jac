import {*} with "./nodes.jac";

walker init{
    root{
        spawn here --> graph::faq;
        spawn here walker::talker;
    }
}
graph faq{
    has anchor FAQ_root;
    spawn{
        FAQ_root = spawn node::faq_root;
        data = file.load_json("faq.json");
        e=0;
        for i in data{
            e=e;
            spawn FAQ_root -[trans_intent(intent = data[e]["Question"])]->node::state(answers = data[e]["Answer"]);
            e+=1;
        }
    }
}
walker talker{
    has utterance;
    has answer;
    has phone_number;
    has user_ctx = {
        "last_node": null,
        "next_node": null,
        "intent": null
    };
    root{
        take -->node::faq_root;
    }
    faq_root{
        here::classify_intent;
        here::process;
        take -[trans_intent(intent == visitor.user_ctx["intent"])]->node::state;
    }
    state{
        here::process;
        here::nlg;
        disengage;
    }
}