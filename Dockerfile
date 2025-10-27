FROM legendexp/legend-pjbase:latest

# Note: use
#
# DOCKER_BUILDKIT=1 docker build --ssh default -t legendexp/legend-pjsoftware:latest .
#
# to build.


# Add GitHub SSH host key

RUN true \
    && mkdir -p ~/.ssh \
    && ssh-keyscan -t rsa github.com > ~/.ssh/known_hosts


# Install LEGEND Python packages:

RUN cd "$PIXI_GLOBALPRJ" && pixi add --pypi \
    pygama==2.2.4 \
    pylegendmeta==1.3.1 \
    fcio==0.9.0


# Install LEGEND Julia base packages:

COPY provisioning/install-sw-scripts/juliapackages-* provisioning/install-sw-scripts/

ENV \
    JULIA_CPU_TARGET="generic;sandybridge,-xsaveopt,clone_all;haswell,-rdrnd,base(1);x86-64-v4,-rdrnd,base(1)" \
    JULIA_PKG_PRESERVE_TIERED_INSTALLED="true"

RUN provisioning/install-sw.sh juliapackages legend-exp/a81ff67 /opt/legend-julia-base-env
