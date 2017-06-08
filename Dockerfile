FROM  haskell

# create our src and bin directories and 
# setup src to be our working directory
RUN mkdir -p /opt/game-of-life/src
RUN mkdir -p /opt/game-of-life/bin
WORKDIR /opt/game-of-life/src

# setup our PATH for the bin directory
ENV PATH "$PATH:/opt/game-of-life/bin"

# Install GHC using stack, based on the stack.yaml file.
COPY ./stack.yaml /opt/game-of-life/src/stack.yaml
RUN stack --no-terminal setup

# Install all dependencies in the .cabal file.
COPY ./game-of-life.cabal /opt/game-of-life/src/game-of-life.cabal
RUN stack --no-terminal test --only-dependencies

# Build application
COPY . /opt/game-of-life/src
RUN stack --no-terminal build

# Install application binaries to /opt/game-of-life/bin.
RUN stack --no-terminal --local-bin-path /opt/game-of-life/bin install

CMD /opt/game-of-life/bin/game-of-life -p $PORT