FROM openjdk:8

RUN wget https://dl.google.com/go/go1.13.9.linux-amd64.tar.gz \
    && tar -xvzf go1.13.9.linux-amd64.tar.gz \
    && mv go /usr/local/go-1.13

ENV GOROOT=/usr/local/go-1.13
ENV PATH=$GOROOT/bin:$PATH

WORKDIR /app

COPY . /app

EXPOSE 8080
EXPOSE 443

CMD ["bash", "-c", "run.sh localhost 443"]