function Listen_Safe()
    ExecuteCommand("me Introduce combinatia")
    ped:Play_Animation("mini@safe_cracking", "dial_turn_anti_fast", false, true)
    Wait(4000)
    ped:Stop_Animation()
    TriggerServerEvent("kraneCase:Show_Safe_Contents")
end