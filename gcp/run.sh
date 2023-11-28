gcloud compute instances create nv-dev \
    --machine-type=a2 \
    --zone=us-east1 \
    --boot-disk-size=40GB \
    --image=IMAGE \
    --image-project=IMAGE_PROJECT \
    --maintenance-policy=TERMINATE --restart-on-failure \
    [--preemptible] \
    [--accelerator=type=nvidia-l4-vws,count=VWS_ACCELERATOR_COUNT]
