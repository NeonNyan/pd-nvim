if exists("b:current_syntax")
  finish
endif

syntax keyword ModconfigStageKeyword stage
syntax keyword ModconfigStageProperty bgfile tilesfile padsfile setupfile alarm
syntax keyword ModconfigMusicKeyword music primarytrack xtrack
syntax keyword ModconfigWeatherKeyword weather exclude_rooms clear
syntax match ModconfigComment /#.*$/
syntax match ModconfigHexValue /0x[0-9a-fA-F]\+/
syntax region ModconfigString start=/"/ end=/"/

highlight link ModconfigStageKeyword Keyword
highlight link ModconfigStageProperty Identifier
highlight link ModconfigMusicKeyword Keyword
highlight link ModconfigWeatherKeyword Keyword
highlight link ModconfigHexValue Tag
highlight link ModconfigString String
highlight link ModconfigComment Comment

let b:current_syntax = "modconfig"
