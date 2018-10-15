#!/bin/bash

##### Beginning of file

set -ev

export JULIA_FLAGS="--check-bounds=yes --code-coverage=all --color=yes --compiled-modules=yes --inline=no"
echo "JULIA_FLAGS=$JULIA_FLAGS"

julia $JULIA_FLAGS -e 'import Pkg; Pkg.build("MirrorUpdater");'
julia $JULIA_FLAGS -e 'import MirrorUpdater;'
julia $JULIA_FLAGS -e 'import Pkg; Pkg.test("MirrorUpdater"; coverage=true);'

cat Project.toml
cat Manifest.toml

julia $JULIA_FLAGS -e 'import Pkg; try Pkg.add("Coverage") catch end;'
julia $JULIA_FLAGS -e '
    import Coverage;
    import MirrorUpdater;
    cd(MirrorUpdater.package_directory());
    Coverage.Codecov.submit(Coverage.Codecov.process_folder());
    '

##### End of file
