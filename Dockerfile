# Can use mirrors instead
FROM texlive/texlive:latest

# Use Chinese apt mirror
RUN sed -i 's|deb.debian.org|mirrors.aliyun.com|g' /etc/apt/sources.list.d/debian.sources 2>/dev/null || \
    sed -i 's|deb.debian.org|mirrors.aliyun.com|g' /etc/apt/sources.list 2>/dev/null || true

# Install CJK fonts and tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    fonts-noto-cjk \
    fonts-noto-cjk-extra \
    fontconfig \
    ripgrep \
    git \
    make \
    && rm -rf /var/lib/apt/lists/* \
    && fc-cache -fv

WORKDIR /workspace
