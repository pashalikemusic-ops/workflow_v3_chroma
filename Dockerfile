FROM runpod/worker-comfyui:5.5.1-base

# Custom nodes (IPAdapter for face consistency + LoadImageBase64)
RUN cd /comfyui/custom_nodes && \
    git clone https://github.com/Shakker-Labs/ComfyUI-IPAdapter-Flux.git && \
    git clone https://github.com/Acly/comfyui-tooling-nodes.git && \
    cd ComfyUI-IPAdapter-Flux && pip install -r requirements.txt

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

# IPAdapter model (5.3 GB) — wget same as other models, verify file size > 1GB
RUN mkdir -p /comfyui/models/ipadapter-flux && \
    wget -O /comfyui/models/ipadapter-flux/ip-adapter.bin \
    "https://huggingface.co/InstantX/FLUX.1-dev-IP-Adapter/resolve/main/ip-adapter.bin" && \
    test $(stat -c%s /comfyui/models/ipadapter-flux/ip-adapter.bin) -gt 1000000000 && \
    echo "IPAdapter downloaded OK: $(ls -lh /comfyui/models/ipadapter-flux/ip-adapter.bin)"

# Pre-download SigLIP vision model so it doesn't download at runtime
RUN python3 -c "from transformers import SiglipImageProcessor, SiglipVisionModel; SiglipImageProcessor.from_pretrained('google/siglip-so400m-patch14-384'); SiglipVisionModel.from_pretrained('google/siglip-so400m-patch14-384')" 2>/dev/null || true

# 4x-UltraSharp upscaler
RUN wget -q --show-progress -O /comfyui/models/upscale_models/4x-UltraSharp.pth \
    "https://huggingface.co/Kim2091/UltraSharp/resolve/main/4x-UltraSharp.pth"
