FROM python:3.10 AS base
ENV VIRTUAL_ENV=/opt/venv
ENV PATH="$VIRTUAL_ENV/bin:/root/.cargo/bin:${PATH}"
WORKDIR /app/
RUN python -m venv $VIRTUAL_ENV
RUN pip install --upgrade pip
RUN apt-get update && apt-get install -y build-essential
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt
COPY aleo-explorer-rust aleo-explorer-rust
RUN pip install ./aleo-explorer-rust

FROM base AS runtime
COPY --from=base $VIRTUAL_ENV $VIRTUAL_ENV
COPY . .
CMD ["python3", "main.py"]
