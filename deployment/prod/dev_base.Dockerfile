# Copyright 2023 Ant Group Co., Ltd.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# FROM secretflow/teeapps-gcc11-dev:0.1.0b0 as builder
FROM intelanalytics/bigdl-ppml-trusted-big-data-ml-scala-occlum:2.5.0-SNAPSHOT as bigdl
FROM mebrz/teeapps-gcc11-dev:0.1.0b0 as builder

WORKDIR /home/admin/dev

COPY .bazelrc .bazelversion build.sh BUILD.bazel Occlum.json python.yaml WORKSPACE ./
COPY teeapps ./teeapps
COPY integration_test ./integration_test
COPY sources-20.04-tsinghua.list /etc/apt/sources.list
RUN pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
RUN conda config --remove-key channels && \
    conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main && \
    conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free && \
    conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/r && \
    conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/pro && \
    conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/msys2 && \
    conda config --set show_channel_urls yes
COPY bazel ./bazel
COPY deployment/conf/unified_attestation.json ./deployment/conf/unified_attestation.json

# prepare Spark
RUN apt-get update && DEBIAN_FRONTEND="noninteractive" apt-get install -y --no-install-recommends \
        openjdk-8-jdk
COPY --from=bigdl /opt/spark /opt/spark
# remove slf4j-reload4j-1.7.35.jar 文件
RUN rm -f /opt/spark/jars/slf4j-reload4j-1.7.35.jar
COPY --from=bigdl /opt/libhadoop.so /opt/libhadoop.so
ENV SPARK_HOME=/opt/spark
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
RUN ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts && bash build.sh

