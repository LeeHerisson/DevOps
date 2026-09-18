   #!/bin/bash
   echo "Creating backup..."
   mkdir -p backup
   cp -r src backup/
   cp -r docs backup/
   echo "Backup completed!"
   ls -la backup/

