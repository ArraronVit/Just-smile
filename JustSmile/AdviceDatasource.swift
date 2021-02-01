//
//  AdviceDatasource.swift
//  CoreML_test
//
//  Created by Vitaly Kozlov on 01.02.2021.
//

import Foundation

class AdviceDatasource {
    
    public static func getHappyAdvice() -> String {
        let advices = ["Your smile as good as running some code with exit code 0 at first time!", "You look so good! Do you want to learn a few python lessons?", "I'm sorry, are you by any chance a С++ programmer?", "I see you are quite happy, pls share your execution environment with my interpreter!", "Maybe we should setup some socket connection between us?","I'm sorry, in you opinion is it possible to receive from you code 200 on my request: 'Can I join you?'"]
        
        let advice = advices.randomElement()!
        return advice
    }
    
    public static func getSadAdvice() -> String {
        let advices = ["I see you have some NPE problems, may I become your debugger?", "Looks like you have exit code 1, can I become your StackOverflow?", "Hey, I see your mood connected to wrong gateaway, may I change your host on some positive address?", "Hey! do you have some issues? may be i can help you with a few hotfixes?", "Hey, I see your Emotion FSM is in wrong state, mayby you need some transition to another one? ", "Hi, It seems like your current SCRUM sprint are not so good. Maybe I can fix this issue?"]
        
        let advice = advices.randomElement()!
        return advice
    }
    
    public static func getNeutralAdvice() -> String {
        let advices = ["Hey, I see your finite state is Idle, may I apply an epsilon transition to you?", "Hello, I've noticed that your mood are undefined, can I join to you and add initializer syntax to your mood?", "Hy, in your opinion is it possible to refactor you architecture from monolite to microservices on two nodes?", "Hi, can I join to your private session?", "Hello, don't mind if I apply DI to your mood constructor? ", "Hey, can we setup web bridge 3 between us?"]
        
        let advice = advices.randomElement()!
        return advice
    }
    
    public static func getSurpriseAdvice() -> String {
        let advices = ["Hi, looks like you have some ancaughted exceptions. May be I can become your catch block?", "Hello, I've noticed that you have some warnings in your sources. Can we explore them together?", "Hey, looks like your data unnormalized, maybe we should fix it? ", "Hello there, you look like compiler during executing blackbox code! ", "Hey, may I ask why you look like my parents after I've reloaded their router?", "Hello, you look like my collegues receiving some issues from manager in 2 days before release date!"]
        
        let advice = advices.randomElement()!
        return advice
    }
    
    public static func getAngryAdvice() -> String {
        let advices = ["Hi, can I apply Silent modifier to your warnings?", "Hey, looks like you have too many issues in your repository, can I become your collaborator?", "Hello, can I help you to resolve some merge conflits?", "Hey, let's interrupt your current process and launch it on other thread.", "Hello there, can I refresh your mood?", "Hi, looks like you worried abouth smth. Maybe you should reconfigure this output to Dev/null?"]
        
        let advice = advices.randomElement()!
        return advice
    }
    
    public static func getFearAdvice() -> String {
        
        let advices = ["Hey, looks like you have warnings in execution process, maybe you should just ignore them?", "Hi, may i interest about your interpretation warnings?", "Hi, don't be like IDE when you defined unused value!", "Hi, looks like you was bitten by Trainee without work experience on the first work!", "Hello, looks like you Jun on first code review. Maybe you need some help from senior dev?", "Hello there, you aren't looking like 1C programmer in the company of C++ developers. So you don't have reasons for fear!"]
        
        let advice = advices.randomElement()!
        return advice
    }
    
    
}
