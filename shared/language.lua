Language = {}

-- Keeps state for Language
Language.State = {
    AssignedLanguage = "en",
    Locales = {}
}

-- Sets assigned language
Language.SetLanguage = function(language)
    Language.State.AssignedLanguage = language
    return Language
end

-- Loads the locale file
Language.LoadLocales = function ()
    local localesFile = LoadResourceFile(GetCurrentResourceName(), "./locales/" .. Language.State.AssignedLanguage .. ".json")
    
    if localesFile then
        local localesDecoded = json.decode(localesFile)
        Language.State.Locales = localesDecoded
        return true
    end

    print('^1Error:^0 Unable to find locales for language: ' .. Language.State.AssignedLanguage)
    return false
end

-- Returns locales set
Language.GetLocales = function ()
    return Langage.State.Locales
end

-- Sets locales that are passed to state
Language.SetLocales = function (locales)
    if type(locales) ~= "table" then
        return print('^1Error:^0 SetLocales requires parameter 1 to be of type `table`')
    end

    Language.State.Locales = locales
    return true
end

-- Gets a locale from the table and merges the tags if applicable
Language.Locale = function (key, mergeTags)
    local locale = ""

    if not Language.State.Locales[key] then
        return Language.ConsoleError('Unable to find locale.' .. key)
    end

    locale = Language.State.Locales[key]

    if mergeTags then
        if type(mergeTags) == "table" then
            for k, v in pairs(mergeTags) do
                locale = locale:gsub("{" .. k .. "}", v)
            end
        end
    end

    return locale
end

-- Handles a string without validating mergeTags against locale keys
Language.ProcessString = function (message, mergeTags)
    for k, v in pairs(mergeTags) do
        if type(v) == "table" then
            message = Language.ProcessString(message, v)
        else
            message = message:gsub("{" .. string.lower(k) .. "}", v)
        end
    end

    return message
end

-- Outputs a console error
Language.ConsoleError = function (message)
    print('^1Error:^0 ' .. message)
end