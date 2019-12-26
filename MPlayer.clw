   PROGRAM



   INCLUDE('ABERROR.INC'),ONCE
   INCLUDE('ABUTIL.INC'),ONCE
   INCLUDE('ERRORS.CLW'),ONCE
   INCLUDE('KEYCODES.CLW'),ONCE
   INCLUDE('ABFUZZY.INC'),ONCE

   MAP
     MODULE('MPLAYER_BC.CLW')
DctInit     PROCEDURE                                      ! Установка модулей
DctKill     PROCEDURE                                      ! Удаление словарей
     END
!--- Application Global and Exported Procedure Definitions --------------------------------------------
     MODULE('MPLAYER001.CLW')
Frame                  PROCEDURE   !
     END
   END

GLO:uiMode           CSTRING(30)
GLO:Test             BYTE
GLO:MediaFile        CSTRING(255)
GLO:FullScreen       BYTE
GLO:MplayerHandle    LONG
SilentRunning        BYTE(0)                               !  Включения тихого режима

!region File Declaration
!endregion

EVENT:PlayMedia     Equate(404h)
EVENT:FullScreen     Equate(404h)

FuzzyMatcher         FuzzyClass                            ! Глобальный fuzzy matcher
GlobalErrorStatus    ErrorStatusClass,THREAD
GlobalErrors         ErrorClass                            ! Глобальный менджер ошибок
INIMgr               CLASS(INIClass)                       ! Глобальный non-volatile менджер хранилищя
Fetch                  PROCEDURE(),DERIVED
Update                 PROCEDURE(),DERIVED
                     END

GlobalRequest        BYTE(0),THREAD                      
GlobalResponse       BYTE(0),THREAD                    
VCRRequest           LONG(0),THREAD                      

Dictionary           CLASS,THREAD
Construct              PROCEDURE
Destruct               PROCEDURE
                     END


  CODE
  GlobalErrors.Init(GlobalErrorStatus)
  FuzzyMatcher.Init                                      
  FuzzyMatcher.SetOption(MatchOption:NoCase, 1)          
  FuzzyMatcher.SetOption(MatchOption:WordOnly, 0)       
  INIMgr.Init('.\MPlayer.INI', NVD_INI)                  
  DctInit
  SYSTEM{PROP:Icon} = 'sv.ico'
  Frame
  INIMgr.Update
  INIMgr.Kill                                            
  FuzzyMatcher.Kill                                      


Dictionary.Construct PROCEDURE

  CODE
  IF THREAD()<>1
     DctInit()
  END


Dictionary.Destruct PROCEDURE

  CODE
  DctKill()


INIMgr.Fetch PROCEDURE

  CODE
  GLO:uiMode = SELF.TryFetch('Preserved','GLO:uiMode')   
  GLO:Test = SELF.TryFetch('Preserved','GLO:Test')    
  PARENT.Fetch


INIMgr.Update PROCEDURE

  CODE
  PARENT.Update
  SELF.Update('Preserved','GLO:uiMode',GLO:uiMode)        
  SELF.Update('Preserved','GLO:Test',GLO:Test)  

