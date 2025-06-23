FROM jenkins/jenkins:lts

USER root

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    unzip \
    gnupg \
    ca-certificates \
    apt-transport-https \
    software-properties-common \
    fontconfig \
    libxss1 \
    libappindicator3-1 \
    libasound2 \
    libatk-bridge2.0-0 \
    libgtk-3-0 \
    libnss3 \
    libx11-xcb1 \
    libxcomposite1 \
    libxcursor1 \
    libxdamage1 \
    libxrandr2 \
    xdg-utils \
    --no-install-recommends

# Download dan install Microsoft OpenJDK 21 (tar.gz)
ENV JAVA_VERSION=21.0.7
ENV JAVA_BUILD=6

RUN mkdir -p /opt/java && \
    wget -q https://aka.ms/download-jdk/microsoft-jdk-${JAVA_VERSION}-linux-aarch64.tar.gz -O /tmp/jdk.tar.gz && \
    tar -xzf /tmp/jdk.tar.gz -C /opt/java && \
    rm /tmp/jdk.tar.gz && \
    ls /opt/java

# Set JAVA_HOME dan PATH
ENV JAVA_HOME=/opt/java/jdk-${JAVA_VERSION}+${JAVA_BUILD}
ENV PATH=$JAVA_HOME/bin:$PATH

RUN java --version

# Install Maven
ENV MAVEN_VERSION=3.9.10
RUN mkdir -p /opt/mvn && \
    wget https://dlcdn.apache.org/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz -O /tmp/mvn.tar.gz && \
    tar -xzf /tmp/mvn.tar.gz -C /opt/mvn && \
    rm /tmp/mvn.tar.gz && \
    ls /opt/mvn

ENV MAVEN_HOME=/opt/mvn/apache-maven-${MAVEN_VERSION}
ENV PATH=$MAVEN_HOME/bin:$PATH

RUN mvn --version

# Install Google Chrome Stable
RUN apt update && \
    apt install -y --no-install-recommends chromium && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

# Kembali ke user jenkins
USER jenkins
