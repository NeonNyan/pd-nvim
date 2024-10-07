set print pretty on
set pagination off
set output-radix 16

# TODO: set invincible
# TODO: set invisible

define kill_player 
  if $argc != 1
    printf "kill_player: Usage: kill_player <player_id>\n"
    return
  end 
  set g_Vars.players[$arg0].isdead = 1
end

define unlock_mouse
  call inputLockMouse(0)
end

define load_coop_player
  if $argc != 1
    printf "load_player: Usage: load_player <player_id>\n"
    return
  end 

  # this logic was copied from lv.c:lvReset
  call playermgrAllocatePlayer($arg0)

  set $lastplayer = g_Vars.currentplayernum
  call setCurrentPlayerNum($arg0)
  set g_Vars.currentplayer->usedowntime = 0
  set g_Vars.currentplayer->invdowntime = g_Vars.currentplayer->usedowntime

  call menuReset()
  call amReset()
  call invReset()
  call bgunReset()
  call playerLoadDefaults()
  call playerReset()
  call playerSpawn()
  call bheadReset()


  call setCurrentPlayerNum($lastplayer)
end

define load_anti_player
  if $argc != 1
    printf "load_player: Usage: load_player <player_id>\n"
    return
  end 

  # this logic was copied from lv.c:lvReset
  call playermgrAllocatePlayer($arg0)

  set $lastplayer = g_Vars.currentplayernum
  call setCurrentPlayerNum($arg0)
  set g_Vars.antiplayernum = $arg0
  set g_Vars.antiplayers[$arg0] = g_Vars.currentplayer
  set g_Vars.currentplayer->usedowntime = 0
  set g_Vars.currentplayer->invdowntime = g_Vars.currentplayer->usedowntime

  call menuReset()
  call amReset()
  call invReset()
  call bgunReset()
  call playerLoadDefaults()
  call playerReset()
  call playerSpawn()
  call bheadReset()



  call setCurrentPlayerNum($lastplayer)
end

# vim: set ft=gdb tabstop=2 shiftwidth=2 expandtab:
