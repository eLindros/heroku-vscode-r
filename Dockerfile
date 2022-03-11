# Start from the code-server Debian base image
FROM codercom/code-server:4.0.2

USER coder

# Apply VS Code settings
COPY deploy-container/settings.json .local/share/code-server/User/settings.json

# Use bash shell
ENV SHELL=/bin/bash

# Fix permissions for code-server
RUN sudo chown -R coder:coder /home/coder/.local

# You can add custom software and dependencies for your environment below
# -----------

# Install a VS Code extension:
# Note: we use a different marketplace than VS Code. See https://github.com/cdr/code-server/blob/main/docs/FAQ.md#differences-compared-to-vs-code
RUN code-server --install-extension 9j.amvim
RUN code-server --install-extension Ikuyadeu.r
RUN code-server --install-extension RDebugger.r-debugger


# Install R
RUN sudo apt-get update
# RUN sudo apt-get install -y r-base r-base-dev
RUN sudo apt install --assume-yes --no-install-recommends build-essential libcurl4-openssl-dev libssl-dev libxml2-dev r-base libfontconfig1-dev libcairo2-dev

COPY init.R .local/share/code-server/User/init.R
RUN sudo Rscript .local/share/code-server/User/init.R

# Port
ENV PORT=8080

# Use our custom entrypoint script first
COPY deploy-container/entrypoint.sh /usr/bin/deploy-container-entrypoint.sh
ENTRYPOINT ["/usr/bin/deploy-container-entrypoint.sh"]
