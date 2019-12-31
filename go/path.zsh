export GOPATH=$PROJECTS/go
if [ -d /usr/local/go/bin ]; then
    export PATH="/usr/local/go/bin:$PATH"
fi
export PATH="$GOPATH/bin:$PATH"
