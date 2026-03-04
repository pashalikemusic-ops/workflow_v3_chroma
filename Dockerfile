FROM runpod/worker-comfyui:5.5.1-base

# Custom nodes: LoadImageBase64
RUN cd /comfyui/custom_nodes && \
    git clone https://github.com/Acly/comfyui-tooling-nodes.git

# PuLID for Chroma (face consistency — special fork with Chroma support)
RUN cd /comfyui/custom_nodes && \
    git clone https://github.com/PaoloC68/ComfyUI-PuLID-Flux-Chroma.git && \
    cd ComfyUI-PuLID-Flux-Chroma && pip install -r requirements.txt

# Impact Pack (FaceDetailer — face detection + re-rendering)
RUN cd /comfyui/custom_nodes && \
    git clone https://github.com/ltdrdata/ComfyUI-Impact-Pack.git && \
    cd ComfyUI-Impact-Pack && pip install -r requirements.txt && \
    cd /comfyui/custom_nodes && \
    git clone https://github.com/ltdrdata/ComfyUI-Impact-Subpack.git ComfyUI-Impact-Pack/impact_subpack

# Chroma 1.0 HD — uncensored diffusion model (fp8, 8.8 GB)
RUN mkdir -p /comfyui/models/diffusion_models && \
    wget -q --show-progress -O /comfyui/models/diffusion_models/Chroma1-HD-fp8mixed-final.safetensors \
    "https://huggingface.co/silveroxides/Chroma1-HD-fp8-scaled/resolve/main/Chroma1-HD-fp8mixed-final.safetensors"

# Flan-T5 XXL encoder (recommended for Chroma, fp8 scaled)
RUN mkdir -p /comfyui/models/clip && \
    wget -q --show-progress -O /comfyui/models/clip/flan-t5-xxl_fp8_scaled.safetensors \
    "https://huggingface.co/silveroxides/flan-t5-xxl-encoder-only/resolve/main/flan-t5-xxl_float8_e4m3fn_scaled_stochastic.safetensors"

# FLUX VAE (shared with FLUX models)
RUN mkdir -p /comfyui/models/vae && \
    wget -q --show-progress -O /comfyui/models/vae/ae.safetensors \
    "https://huggingface.co/cocktailpeanut/xulf-dev/resolve/main/ae.safetensors"

# PuLID model (1.06 GB)
RUN mkdir -p /comfyui/models/pulid && \
    wget -q --show-progress -O /comfyui/models/pulid/pulid_flux_v0.9.1.safetensors \
    "https://huggingface.co/guozinan/PuLID/resolve/main/pulid_flux_v0.9.1.safetensors"

# EVA CLIP for PuLID face encoding
RUN mkdir -p /comfyui/models/clip && \
    wget -q --show-progress -O /comfyui/models/clip/EVA02_CLIP_L_336_psz14_s6B.pt \
    "https://huggingface.co/QuanSun/EVA-CLIP/resolve/main/EVA02_CLIP_L_336_psz14_s6B.pt"

# InsightFace AntelopeV2 for face detection (PuLID dependency)
RUN mkdir -p /comfyui/models/insightface/models/antelopev2 && \
    wget -q -O /tmp/antelopev2.zip \
    "https://huggingface.co/MonsterMMORPG/tools/resolve/main/antelopev2.zip" && \
    unzip -o /tmp/antelopev2.zip -d /comfyui/models/insightface/models/antelopev2/ && \
    rm /tmp/antelopev2.zip

# YOLO face detection model for FaceDetailer
RUN mkdir -p /comfyui/models/ultralytics/bbox && \
    wget -q --show-progress -O /comfyui/models/ultralytics/bbox/face_yolov8m.pt \
    "https://huggingface.co/Bingsu/adetailer/resolve/main/face_yolov8m.pt"

# 4x-UltraSharp upscaler
RUN wget -q --show-progress -O /comfyui/models/upscale_models/4x-UltraSharp.pth \
    "https://huggingface.co/Kim2091/UltraSharp/resolve/main/4x-UltraSharp.pth"
