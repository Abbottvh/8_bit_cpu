FROM debian:bullseye

RUN apt update && \
    DEBIAN_FRONTEND=noninteractive apt install -y \
    gtkwave x11-apps

CMD ["gtkwave"]
