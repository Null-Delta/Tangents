//
//  Function.swift
//  Tangents
//
//  Created by Рустам Хахук on 25.12.2020.
//

import Foundation

class Function {
    private static var mainActions = ["+","-","*","/","^"]
    
    static func calculate(function: String, value: CGFloat) -> CGFloat {
        var operators: [String] = []
        var actions: [String] = []
        var result: CGFloat = 0.0
        var lastIndex = 0
        var i = 0

        while(i < function.count - 1) {
            
            if mainActions.contains(function[i]) {
                operators.append(function[lastIndex..<i])
                actions.append(function[i])
                lastIndex = i + 1
            }
            
            if function[i] == "(" {
                let end = getBackert(start: i, function: function)
                
                operators.append("\(function[lastIndex..<i])(\(calculate(function: removeIn(string: function[i..<end]),value: value)))")

                lastIndex = end
                i = end

                if i < function.count - 1 {
                    actions.append(function[i])
                    i += 1
                    lastIndex += 1
                }

                continue
            }
            
            i += 1
        }
        
        operators.append(removeIn(string: function[lastIndex..<function.count]))

        while(actions.count > 0) {
            var val: CGFloat = 0
            let index = getPriorityActionIndex(actions: actions)
            
            switch actions[index] {
            case "+":
                val = parseValue(function: removeIn(string: operators[index]), value: value) + parseValue(function: removeIn(string: operators[index + 1]), value: value)
            case "-":
                val = parseValue(function: removeIn(string: operators[index]), value: value) - parseValue(function: removeIn(string: operators[index + 1]), value: value)
            case "/":
                val = parseValue(function: removeIn(string: operators[index]), value: value) / parseValue(function: removeIn(string: operators[index + 1]), value: value)
            case "*":
                val = parseValue(function: removeIn(string: operators[index]), value: value) * parseValue(function: removeIn(string: operators[index + 1]), value: value)
            case "^":
                val = pow(parseValue(function: removeIn(string: operators[index]), value: value), parseValue(function: removeIn(string: operators[index + 1]), value: value))
            default:
                break
            }
            
            actions.remove(at: index)
            operators.remove(at: index + 1)
            operators.remove(at: index)
            operators.insert("\(val)", at: index)
        }
                        
        result = parseValue(function: removeIn(string: operators[0]), value: value)
        
        return result
    }
    
    static func differetial(function: String) -> String {
        var operators: [String] = []
        var actions: [String] = []
        var indexes: [Int] = []
        
        var lastIndex = 0
        var i = 0
        
        while(i < function.count - 1) {
            
            if mainActions.contains(function[i]) {
                operators.append(function[lastIndex..<i])
                actions.append(function[i])
                indexes.append(i)
                lastIndex = i + 1
            }
            
            if function[i] == "(" {
                let end = getBackert(start: i, function: function)
                
                operators.append("\(function[lastIndex..<i])(\(removeIn(string: function[i..<end])))")

                lastIndex = end
                i = end

                if i < function.count - 1 {
                    actions.append(function[i])
                    indexes.append(i)
                    i += 1
                    lastIndex += 1
                }

                continue
            }
            
            i += 1
        }
        
        operators.append(removeIn(string: function[lastIndex..<function.count]))
        
        print(operators)
        print(actions)
        print()
        
        if actions.count == 0 {
            return parseDifValue(function: operators[0])
        } else if actions.contains("+") || actions.contains("-") {
            let actionIndex = min(actions.firstIndex(of: "+") ?? actions.count + 1, actions.firstIndex(of: "-") ?? actions.count + 1)
            let index = indexes[actionIndex]
            let f1 = function[0..<index]
            let f2 = function[index + 1..<function.count]
            
            return "(\(differetial(function: f1)))\(actions[actionIndex])(\(differetial(function: f2)))"
            
        } else if actions.contains("*") || actions.contains("/") {
            let actionIndex = min(actions.firstIndex(of: "*") ?? actions.count + 1, actions.firstIndex(of: "/") ?? actions.count + 1)
            let index = indexes[actionIndex]
            let f1 = function[0..<index]
            let f2 = function[index + 1..<function.count]
            
            if actions[actionIndex] == "*" {
                return "(\(differetial(function: f1)))*(\(f2))+(\(f1))*(\(differetial(function: f2)))"
            } else {
                return "((\(differetial(function: f1)))*(\(f2))-(\(f1))*(\(differetial(function: f2))))/((\(f2))^2)"
            }
        } else if actions.contains("^") {
            let actionIndex = actions.firstIndex(of: "^")!
            let index = indexes[actionIndex]
            let f1 = function[0..<index]
            let f2 = function[index + 1..<function.count]
            
            
            return "(\(f1))^(\(f2))*(\(differetial(function: f2))*ln(\(f1))+\(f2)*(1/(\(f1)))*\(differetial(function: f1)))"
        }
        
        return ""
        
    }
    
    static func convertNormal(function: String) -> String {
    var operators: [String] = []
    var actions: [String] = []
    var indexes: [Int] = []
    
    var lastIndex = 0
    var i = 0
    
    while(i < function.count - 1) {
        
        if mainActions.contains(function[i]) {
            operators.append(function[lastIndex..<i])
            actions.append(function[i])
            indexes.append(i)
            lastIndex = i + 1
        }
        
        if function[i] == "(" {
            let end = getBackert(start: i, function: function)
            
            operators.append("\(function[lastIndex..<i])(\(removeIn(string: function[i..<end])))")

            lastIndex = end
            i = end

            if i < function.count - 1 {
                actions.append(function[i])
                indexes.append(i)
                i += 1
                lastIndex += 1
            }

            continue
        }
        
        i += 1
    }
    
    operators.append(removeIn(string: function[lastIndex..<function.count]))
        
    if actions.count > 0 {
        for i in 0..<actions.count+1 {
            operators[i] = convertNormal(function: removeIn(string:operators[i]))
        }

        
        mainWhile: while(true) {
            for i in 0..<actions.count {
                if actions[i] == "*" && (removeIn(string: operators[i]) == "0" || removeIn(string: operators[i + 1]) == "0") {
                    operators.remove(at: i)
                    operators[i] = "0"
                    actions.remove(at: i)
                    continue mainWhile
                } else if actions[i] == "*" && (removeIn(string: operators[i]) == "1" || removeIn(string: operators[i + 1]) == "1") {
                    actions.remove(at: i)
                    
                    if removeIn(string: operators[i]) == "1" {
                        operators.remove(at: i)
                    } else {
                        operators.remove(at: i + 1)
                    }
                    continue mainWhile
                }
            }
            
            break
        }
    }
        
        print("check result")
        print(operators)
        print(actions)

    var result = ""
    if actions.count != 0 {
        for i in 0..<actions.count {
            result += "(\(operators[i]))\(actions[i])"
        }
        result += "(\(operators[actions.count]))"
    } else {
        result = operators.first!
    }
    
    return result
}
    
    private static func getBackert(start: Int, function: String) -> Int {
        var count = 1
        var i = start + 1
        
        while count > 0 {
            count += (function[i] == "(") ? 1 : ((function[i] == ")") ? -1 : 0)
            i += 1
        }
        
        return i
    }
    
    private static func removeIn(string: String) -> String {
        if string.hasPrefix("(") && string.hasSuffix(")") {
            return string[1..<string.count - 1]
        }
        
        return string
    }
    
    private static func getPriorityActionIndex(actions:[String]) -> Int {
        if actions.contains("^") {return actions.firstIndex(of: "^")!}
        if actions.contains("*") || actions.contains("/") {return min(actions.firstIndex(of: "*") ?? actions.count,actions.firstIndex(of: "/") ?? actions.count)}
        if actions.contains("+") || actions.contains("-") {return min(actions.firstIndex(of: "+") ?? actions.count,actions.firstIndex(of: "-") ?? actions.count)}
        return 0
    }
        
    private static func parseValue(function: String, value: CGFloat) -> CGFloat {
        if function == "t" {
            return value
        } else if Double(function) != nil {
            return CGFloat(Double(function)!)
        } else if function.hasPrefix("ln") {
            return parseLn(function: function, value: value)
        } else if function.hasPrefix("sin") {
            return parseSin(function: function, value: value)
        } else if function.hasPrefix("cos") {
            return parseCos(function: function, value: value)
        } else if function.hasPrefix("abs") {
            return parseAbs(function: function, value: value)
        } else if function.hasPrefix("exp") {
            return parseExp(function: function, value: value)
        } else if function == "" {
            return 0
        }
        
        return 0
    }
    
    private static func parseLn(function: String, value: CGFloat) -> CGFloat{
        return log(parseValue(function: function[3..<function.count - 1], value: value))
    }
    
    private static func parseCos(function: String, value: CGFloat) -> CGFloat{
        return cos(parseValue(function: function[4..<function.count - 1], value: value))
    }
    
    private static func parseSin(function: String, value: CGFloat) -> CGFloat{
        return sin(parseValue(function: function[4..<function.count - 1], value: value))
    }
    
    private static func parseAbs(function: String, value: CGFloat) -> CGFloat{
        return abs(parseValue(function: function[4..<function.count - 1], value: value))
    }
    
    private static func parseExp(function: String, value: CGFloat) -> CGFloat{
        return exp(parseValue(function: function[4..<function.count - 1], value: value))
    }
    
    private static func parseDifValue(function: String) -> String {
        print("diffing \(function)")
        
        if function == "t" {
            return "1"
        } else if function.hasPrefix("sin") {
            return "cos(\(function[4..<function.count - 1]))*(\(parseDifValue(function: function[4..<function.count - 1])))"
        } else if function.hasPrefix("cos") {
            return "-sin(\(function[4..<function.count - 1]))*(\(parseDifValue(function: function[4..<function.count - 1])))"
        }else if function.hasPrefix("ln") {
            return "1/(\(function[3..<function.count - 1]))*(\(parseDifValue(function: function[3..<function.count - 1])))"
        }
        
        return "0"
    }
}

extension String {
    subscript(index: Int) -> String {
        get {
            return String(self[self.index(self.startIndex, offsetBy: index)])
        }
    }
    subscript(range: Range<Int>) -> String {
        get {
            var result = ""
            
            for i in range {
                result += self[i]
            }
            return result
        }
    }
}
