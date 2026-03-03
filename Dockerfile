FROM runpod/worker-comfyui:5.5.1-base

# Custom nodes (IPAdapter for face consistency + LoadImageBase64)
RUN cd /comfyui/custom_nodes && \
    git clone https://github.com/Shakker-Labs/ComfyUI-IPAdapter-Flux.git && \
    git clone https://github.com/Acly/comfyui-tooling-nodes.git

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

# IPAdapter model + CLIP Vision (for face consistency)
RUN mkdir -p /comfyui/models/ipadapter && \
    wget -q --show-progress -O /comfyui/models/ipadapter/ip-adapter.bin \
    "https://huggingface.co/InstantX/FLUX.1-dev-IP-Adapter/resolve/main/ip-adapter.bin"

RUN wget -q --show-progress -O /comfyui/models/clip_vision/sigclip_vision_patch14_384.safetensors \
    "https://huggingface.co/Comfy-Org/sigclip_vision_384/resolve/main/sigclip_vision_patch14_384.safetensors"

# 4x-UltraSharp upscaler
RUN wget -q --show-progress -O /comfyui/models/upscale_models/4x-UltraSharp.pth \
    "https://huggingface.co/Kim2091/UltraSharp/resolve/main/4x-UltraSharp.pth"
