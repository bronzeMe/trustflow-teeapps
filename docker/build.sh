base_image_name="mebrz/teeapps-gcc11-dev"
tag_name="0.1.0b0"
# FROM secretflow/teeapps-gcc11-dev:0.1.0b0 as builder
docker build   -t "${base_image_name}:${tag_name}" -f sf-teeapps-dev-ubuntu.Dockerfile .
