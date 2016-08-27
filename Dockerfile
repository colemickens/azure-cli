FROM alpine:3.4

RUN apk add --no-cache --update python3 python3-dev libffi-dev openssl-dev git build-base bash \
	&& python3 -m ensurepip \
	&& rm -r /usr/lib/python*/ensurepip \
	&& pip3 install --upgrade pip setuptools \
	&& rm -r /root/.cache

RUN cd /usr/bin \
	&& ln -sf easy_install-3.5 easy_install \
	&& ln -sf idle3.5 idle \
	&& ln -sf pydoc3.5 pydoc \
	&& ln -sf python3.5 python \
	&& ln -sf python-config3.5 python-config \
	&& ln -sf pip3.5 pip
RUN git clone https://github.com/Azure/azure-cli /tmp/azure-cli
RUN pip3 install --upgrade pip setuptools
RUN cd /tmp/azure-cli && python3 setup.py sdist
ENV AZURE_CLI_DISABLE_POST_INSTALL 1
RUN cd /tmp/azure-cli && pip3 install -f dist/ azure-cli
RUN cd /tmp/azure-cli && for d in src/command_modules/azure-cli-*/; \
	do MODULE_NAME=$(echo $d | cut -d '/' -f 3); \
		cd $d; python setup.py sdist; \
		pip3 install -f dist/ $MODULE_NAME; \
		cd -; \
	done




CMD /bin/bash
