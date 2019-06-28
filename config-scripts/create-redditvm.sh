#!/bin/bash
gcloud compute instances create reddit-app --image-family reddit-full --tags=http-server --restart-on-failure