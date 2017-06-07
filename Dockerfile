FROM  haskell

WORKDIR /opt/server

# Add and Install Application Code
COPY . /opt/server
RUN stack setup 
RUN stack build --copy-bins

CMD ["game-of-life","-p","5000"]