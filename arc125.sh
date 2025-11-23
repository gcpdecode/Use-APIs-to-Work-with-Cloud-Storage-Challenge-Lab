
#!/bin/bash
# Updated Color Variables
HEADER_COLOR=$'\033[1;31m'   # Bold Red
STEP_COLOR=$'\033[1;31m'     # Bold Red
SUCCESS_COLOR=$'\033[1;33m'  # Bold Yellow
ERROR_COLOR=$'\033[0;37m'    # White
INFO_COLOR=$'\033[1;32m'     # Bold Green

ACTION_COLOR=$'\033[1;35m'
RESET=$'\033[0m'
BOLD=$'\033[1m'

clear
# Welcome message
echo "${BLUE_TEXT}${BOLD_TEXT}┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓${RESET_FORMAT}"
echo "${BLUE_TEXT}${BOLD_TEXT}┃           C l o u d o A r c          ┃${RESET_FORMAT}"
echo "${BLUE_TEXT}${BOLD_TEXT}┃               Cloud Lab              ┃${RESET_FORMAT}"
echo "${BLUE_TEXT}${BOLD_TEXT}┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛${RESET_FORMAT}"
echo
echo "${HEADER_COLOR}Starting Google Cloud Storage operations...${RESET}"
echo

# Function to display step messages
step() {
    echo "${STEP_COLOR}${BOLD}----> $1${RESET}"
}

success() {
    echo "${SUCCESS_COLOR}✓ $1${RESET}"
}

# Step 1: Create bucket1.json
step "Creating bucket1.json configuration..."
cat > bucket1.json <<EOF
{  
   "name": "$DEVSHELL_PROJECT_ID-bucket-1",
   "location": "us",
   "storageClass": "multi_regional"
}
EOF
success "bucket1.json created successfully"

# Step 2: Create bucket1
step "Creating first Cloud Storage bucket..."
curl -s -X POST -H "Authorization: Bearer $(gcloud auth print-access-token)" \
     -H "Content-Type: application/json" \
     --data-binary @bucket1.json \
     "https://storage.googleapis.com/storage/v1/b?project=$DEVSHELL_PROJECT_ID"
success "Bucket $DEVSHELL_PROJECT_ID-bucket-1 created successfully"

# Step 3: Create bucket2.json
step "Creating bucket2.json configuration..."
cat > bucket2.json <<EOF
{  
   "name": "$DEVSHELL_PROJECT_ID-bucket-2",
   "location": "us",
   "storageClass": "multi_regional"
}
EOF
success "bucket2.json created successfully"

# Step 4: Create bucket2
step "Creating second Cloud Storage bucket..."
curl -s -X POST -H "Authorization: Bearer $(gcloud auth print-access-token)" \
     -H "Content-Type: application/json" \
     --data-binary @bucket2.json \
     "https://storage.googleapis.com/storage/v1/b?project=$DEVSHELL_PROJECT_ID"
success "Bucket $DEVSHELL_PROJECT_ID-bucket-2 created successfully"

# Step 5: Download the image file
step "Downloading world.jpeg image file..."
curl -s -LO https://github.com/gcpdecode/Use-APIs-to-Work-with-Cloud-Storage-Challenge-Lab/blob/196e0e4c101e12701312bd534ac9f407df74dc96/world.jpeg
success "Image downloaded successfully"

# Step 6: Upload image file to bucket1
step "Uploading image to first bucket..."
curl -s -X POST -H "Authorization: Bearer $(gcloud auth print-access-token)" \
     -H "Content-Type: image/jpeg" \
     --data-binary @world.jpeg \
     "https://storage.googleapis.com/upload/storage/v1/b/$DEVSHELL_PROJECT_ID-bucket-1/o?uploadType=media&name=world.jpeg"
success "Image uploaded"

# Step 7: Copy the image from bucket1 to bucket2
step "Copying image to second bucket..."
curl -s -X POST -H "Authorization: Bearer $(gcloud auth print-access-token)" \
     -H "Content-Type: application/json" \
     --data '{"destination": "$DEVSHELL_PROJECT_ID-bucket-2"}' \
     "https://storage.googleapis.com/storage/v1/b/$DEVSHELL_PROJECT_ID-bucket-1/o/world.jpeg/copyTo/b/$DEVSHELL_PROJECT_ID-bucket-2/o/world.jpeg"
success "Image copied"

# Step 8: Set public access for the image
step "Getting public access permissions..."
cat > public_access.json <<EOF
{
  "entity": "allUsers",
  "role": "READER"
}
EOF

curl -s -X POST --data-binary @public_access.json \
     -H "Authorization: Bearer $(gcloud auth print-access-token)" \
     -H "Content-Type: application/json" \
     "https://storage.googleapis.com/storage/v1/b/$DEVSHELL_PROJECT_ID-bucket-1/o/world.jpeg/acl"
success "Public access granted"

# Verification prompt
read -p "${INFO_COLOR}Please verify task progress up to TASK 4 before continuing (press Y after checking): ${RESET}" -n 1 -r
echo

# Step 9: Delete the image from bucket1
step "Removing image from first bucket..."
curl -s -X DELETE -H "Authorization: Bearer $(gcloud auth print-access-token)" \
     "https://storage.googleapis.com/storage/v1/b/$DEVSHELL_PROJECT_ID-bucket-1/o/world.jpeg"
success "Image deleted successfully"

# Step 10: Delete bucket1
step "Deleting first bucket..."
curl -s -X DELETE -H "Authorization: Bearer $(gcloud auth print-access-token)" \
     "https://storage.googleapis.com/storage/v1/b/$DEVSHELL_PROJECT_ID-bucket-1"
success "Bucket1 deleted successfully"

# Completion message
echo
echo "${GREEN_TEXT}${BOLD_TEXT}=======================================================${RESET_FORMAT}"
echo "${GREEN_TEXT}${BOLD_TEXT}               LAB COMPLETED SUCCESSFULLY!!!           ${RESET_FORMAT}"
echo "${GREEN_TEXT}${BOLD_TEXT}=======================================================${RESET_FORMAT}"
echo

# ====== GCP DECODE Footer ======
echo "${RED_TEXT}${BOLD_TEXT}🎥 Watch more labs on:  ${RESET_FORMAT}"
echo "${WHITE_TEXT}${BOLD_TEXT}CloudoArc — YouTube${RESET_FORMAT}"
