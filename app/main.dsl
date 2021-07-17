import "commonReactions/all.dsl";

context 
{
    input phone: string;
    food: {[x:string]:string;}[]?=null;
}

/**
* Script.
*/

start node root 
{
    do 
    {
        #connectSafe($phone);
        #waitForSpeech(1000);
        #sayText("Hi, this is Yummy Pizza, how may I help you today?");
        wait *;
    }    
    transitions 
    {
        place_order: goto place_order on #messageHasIntent("yes");
        place_order_pizza: goto place_order_pizza on #messageHasIntent("order_pizza");
        no_dice_bye: goto no_dice_bye on #messageHasIntent("no");
    }
}

digression place_order_pizza
{
    conditions {on #messageHasIntent("order_pizza");}
    do 
    {
        #sayText("What kind of pizza would you like?");
        wait *;
    }
    transitions 
    {
       confirm_food_order: goto confirm_food_order on #messageHasData("food");
       pizza_kind: goto pizza_kind on #messageHasIntent("pizza_kind");
    }
    onexit
    {
        confirm_food_order: do {
               set $food =  #messageGetData("food", { value: true });
       }
    }

}

node place_order_pizza
{
    do 
    {
        #sayText("What kind of pizza would you like?");
        wait *;
    }
    transitions 
    {
       confirm_food_order: goto confirm_food_order on #messageHasData("food");
       pizza_kind: goto pizza_kind on #messageHasIntent("pizza_kind");
    }
    onexit
    {
        confirm_food_order: do {
        set $food = #messageGetData("food");
       }
    }
}

node pizza_kind
{
    do 
    {
        #sayText("Umm, we have Pepperoni, Hawaiian, Margherita, Buffalo, Cheese, and Veggie pizza. Which one would you like?");
        wait *;
    }
    transitions 
    {
        confirm_food_order: goto confirm_food_order on #messageHasData("food");
        recommend: goto recommend on #messageHasIntent("unsure");
        no_dice_bye: goto no_dice_bye on #messageHasIntent("changed_mind");
    }
     onexit
    {
        confirm_food_order: do {
               set $food =  #messageGetData("food", { value: true });
       }
    }
}

digression pizza_kind
{
    conditions {on #messageHasIntent("pizza_kind");}
    do 
    {
        #sayText("Umm, we have Pepperoni, Hawaiian, Margherita, Buffalo, Cheese, and Veggie pizza. Which one would you like?");
        wait *;
    }
    transitions 
    {
        confirm_food_order: goto confirm_food_order on #messageHasData("food");
        recommend: goto recommend on #messageHasIntent("unsure");
        no_dice_bye: goto no_dice_bye on #messageHasIntent("changed_mind");
    }
     onexit
    {
        confirm_food_order: do {
               set $food =  #messageGetData("food", { value: true });
       }
    }
}

node recommend
{
    do 
    {
        #sayText("Our most popular one is Pepperoni and I personally love it too. Would you like to try it?");
        wait *;
    }
    transitions 
    {
       confirm_food_order: goto confirm_food_order on #messageHasIntent("yes");
       place_order_pizza: goto place_order_pizza on #messageHasIntent("no");
    }
    onexit
    {
        confirm_food_order: do {
               set $food =  #messageGetData("food", { value: true });
       }
    }
}

digression place_order
{
    conditions {on #messageHasIntent("place_order");}
    do 
    {
        #sayText("Got that! What can I get for you today?");
        wait *;
    }
    transitions 
    {
       confirm_food_order: goto confirm_food_order on #messageHasData("food");
    }
    onexit
    {
        confirm_food_order: do {
               set $food =  #messageGetData("food", { value: true });
       }
    }
}

node place_order
{
    do 
    {
        #sayText("Got that! What can I get for you today?");
        wait *;
    }
    transitions 
    {
       confirm_food_order: goto confirm_food_order on #messageHasData("food");
    }
    onexit
    {
        confirm_food_order: do {
        set $food = #messageGetData("food");
       }
    }
}

node confirm_food_order
{
    do
    {
        #sayText("Perfect. Let me just make sure I got that right. You want ");
        var food = #messageGetData("food");
        for (var item in food)
            {
                #sayText(item.value ?? "and");
            }
        #sayText(" is that right?");
        wait *;
    }
     transitions 
    {
        order_confirmed: goto payment on #messageHasIntent("yes");
        repeat_order: goto repeat_order on #messageHasIntent("no");
    }
}

node repeat_order
{
    do 
    {
        #sayText("Let's try this again. What can I get for you today?");
        wait *;
    }
    transitions 
    {
       confirm_food_order: goto confirm_food_order on #messageHasData("food");
    }
    onexit
    {
        confirm_food_order: do {
        set $food = #messageGetData("food");
       }
    }
}

node payment
{
    do
    {
        #sayText("Great. Will you be paying at the store?");
        wait *;
    }
     transitions 
    {
        in_store: goto pay_in_store on #messageHasIntent("pay_in_store") or #messageHasIntent("yes");
        by_card: goto by_card on #messageHasIntent("pay_by_card") or #messageHasIntent("no");
    }
}

node pay_in_store
{
    do
    {
        #sayText("Your order will be ready in 15 minutes. Once you’re in the store, head to the pickup counter. Anything else I can help you with? ");
        wait *;
    }
     transitions 
    {
        can_help: goto can_help on #messageHasIntent("yes");
        bye: goto success_bye on #messageHasIntent("no");
    }
}

node by_card
{
    do
    {
        #sayText("I'm sorry, I'm just a demo and can't take your credit card number. If okay, would you please pay in store. Your order will be ready in 15 minutes. Anything else I can help you with? ");
        wait *;
    }
     transitions 
    {
        can_help: goto can_help on #messageHasIntent("yes");
        bye: goto success_bye on #messageHasIntent("no");
    }
}

digression drinks 
{
    conditions {on #messageHasIntent("drinks");}
    do 
    {
        #sayText("We have vanilla milkshake and soda. Which one would you like?");
        wait *;
    }
    transitions 
    {
        soda: goto soda on #messageHasIntent("soda");
        milkshake: goto milkshake on #messageHasIntent("milkshake");
    }
}

node soda 
{
    do 
    {
        #sayText("Okay, soda it is. I added it to your order. Would that be all?");
        wait *;
    }
transitions 
    {
        payment: goto payment on #messageHasIntent("yes");
        can_help_then: goto can_help_then on #messageHasIntent("no");
    }
}

node milkshake 
{
    do 
    {
        #sayText("Okay, milkshake it is. I added it to your order. Would that be all?");
        wait *;
    }
transitions 
    {
        payment: goto payment on #messageHasIntent("yes");
        can_help_then: goto can_help_then on #messageHasIntent("no");
    }
    
}

digression delivery 
{
    conditions {on #messageHasIntent("delivery");}
    do 
    {
        #sayText("Unfortunately we only offer pick up service through this channel at the moment. Would you like to place an order for pick up now?");
        wait *;
    }
    transitions 
    {
        place_order: goto place_order on #messageHasIntent("yes");
        can_help_then: goto no_dice_bye  on #messageHasIntent("no");
    }
}

node can_help_then 
{
    do
    {
        #sayText("How can I help you then?");
        wait *;
    }
}

node can_help
{
    do
    {
        #sayText("How can I help?");
        wait *;
    }
}

node success_bye 
{
    do 
    {
        #sayText("Thank you so much for your order. Have a great day. Bye!");
        #disconnect();
        exit;
    }
}

digression bye 
{
    conditions { on #messageHasIntent("bye"); }
    do 
    {
        #sayText("Thanks for your time. Have a great day. Bye!");
        #disconnect();
        exit;
    }
}

node no_dice_bye 
{
    do 
    {
        #sayText("Sorry I couldn't help you today. Have a great day. Bye!");
        #disconnect();
        exit;
    }
}