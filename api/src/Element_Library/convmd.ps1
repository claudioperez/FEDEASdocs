
gci -r -i *.html |foreach{$md=$_.directoryname+"\"+$_.basename+".md";pandoc $_.name -o $md}