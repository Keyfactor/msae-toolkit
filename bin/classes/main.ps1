## Need to add validation on LogLevl and LogDirectory

class WriteLog {
    [String]$LogDirectory
    [String]$Logger
    [String]$LogFile = "main.log"
    [String]$LogLevel = "INFO"
    [String]$Message
    [String]$DefaultColor = "Yellow"
    [Object]$ConsoleColors = @{
        Warning = "Yellow"
    }

    # Update after file and path are passed during construction
    static [String]$LogPath
    static [String]$DefaultConsole = $false
    
    # Empty constructor
    WriteLog(){}
        
    WriteLog([String]$LogDir){
        $this.LogDirectory = $LogDir
        [WriteLog]::LogPath = "$($this.LogDirectory)\$($this.LogFile)"
    }
    WriteLog([String]$LogDir, [String]$LogFile){
        $this.LogFile = $LogFile
        $this.LogDirectory = $LogDir
        [WriteLog]::LogPath = "$($this.LogDirectory)\$($this.LogFile)"
    }
    WriteLog([String]$LogDir, [String]$LogFile, [String]$LogLevel){
        $this.LogFile = $LogFile
        $this.LogDirectory = $LogDir
        $this.LogLevel = $LogLevel
        [WriteLog]::LogPath = "$($this.LogDirectory)\$($this.LogFile)"
    }
    WriteLog([String]$LogDir, [String]$LogFile, [String]$LogLevel, [String]$Logger){
        $this.LogFile = $LogFile
        $this.LogDirectory = $LogDir
        $this.LogLevel = $LogLevel
        $this.Logger = $Logger
        [WriteLog]::LogPath = "$($this.LogDirectory)\$($this.LogFile)"
    }

    # write last message to console
    Console(){
        Write-Host $($this.Message) -ForegroundColor $this.DefaultColor
        $this.Message = $null
    }
    # write last message to console but change color
    Console([String]$Color){
        Write-Host $($this.Message) -ForegroundColor $Color
        $this.Message = $null
    }
    Failed([String[]]$Messages){
        $Color = "Red"
        $OutputConsole = $True
        $this.WriteToLog($Messages,"INFO",$Color,$OutputConsole)
    }
    Success([String[]]$Messages){
        $Color = "Green"
        $OutputConsole = $True
        $this.WriteToLog($Messages,"INFO",$Color,$OutputConsole)
    }
    Info([String[]]$Messages){
        $OutputConsole = $this.DefaultConsole
        $this.WriteToLog($Messages,"INFO",$this.DefaultColor,$OutputConsole)
    }
    Info([String[]]$Messages, [Boolean]$Console){
        $OutputConsole = $Console
        $this.WriteToLog($Messages,"INFO",$this.DefaultColor,$OutputConsole)
    }
    Warn([String[]]$Messages){
        $OutputConsole = $this.DefaultConsole
        $this.WriteToLog($Messages,"WARN",$this.DefaultColor,$OutputConsole)
    }
    Warn([String[]]$Messages, [Boolean]$Console){
        $OutputConsole = $Console
        $this.WriteToLog($Messages,"WARN","Yellow",$OutputConsole)
    }
    Debug([String[]]$Messages){
        $OutputConsole = $this.DefaultConsole
        if($this.LogLevel -eq "DEBUG"){
            $this.WriteToLog($Messages,"DEBUG",$this.DefaultColor,$OutputConsole)
        }
    }
    Error([String[]]$Messages){
        $Color = $this.DefaultColor
        $OutputConsole = $this.DefaultConsole
        $this.WriteToLog($Messages,"ERROR",$Color,$OutputConsole)
        
    }
    Error([String[]]$Messages, [Boolean]$Console){
        $OutputConsole = $Console
        $this.WriteToLog($Messages,"ERROR","Red",$OutputConsole)
    }
    Exception([object]$Exception){
        $OutputConsole = $this.DefaultConsole
        $Messages = (
            "Exception caught $($Exception.ScriptStackTrace)",
            $($Exception[0].Exception)
        )
        $this.WriteToLog($Messages,"ERROR",$this.DefaultColor,$OutputConsole)
    }

    hidden WriteToLog (
        [String[]]$Messages,
        [String]$LogLevel,
        [String]$Color,
        [Bool]$OutputConsole
    ) {
        $Path = [WriteLog]::LogPath
        foreach($Message in $Messages){
            $TimeStamp = (Get-Date).toString("yyyyMMdd HH:mm:ss")
            $LogMessage = "$TimeStamp $LogLevel [$($this.Logger)] $Message"
            $LogMessage | Out-File -FilePath $Path -Append -Encoding utf8

            #if($this.OutputConsole){
            if($OutputConsole){
                Write-Host $Message -ForegroundColor $Color
            }
        }
        $this.Message = $Message
    }
}

class ValidationCheck {
    [String] $Name
    [String] $DisplayName
    [String] $Description
    [String] $Type
    [String] $Status = "Not Checked"
    [String] $Results = "Not Checked"
    [String] $ResultsColor = "Gray"

    ValidationCheck(){}
    ValidationCheck([String] $Name){
        $this.Name = $Name
    }
}
