on run argv
        tell application "Vim"
                set theUnixPath to item 1 of argv
                set theMacPath to (POSIX file theUnixPath) as string
                open file theMacPath
                activate
        end tell
end run
