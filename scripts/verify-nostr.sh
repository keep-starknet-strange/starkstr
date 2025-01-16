#!/bin/bash

# Generate Nostr event data
cd scripts/nostr-data-gen
npm run start
cd ../..

# Build and run Cairo code
scarb build

# We need to pass the values from the generated JSON as arguments
# pubkey: "c44f2be1b2fb5371330386046e60207bbd84938d4812ee0c7a3c11be605a7585"
# sig: "6c398fa11543400a10c1934fb2a28b3f39f78bd87a2d13a060987f39a094c691d82dbd95a20628a376fb337603cbb1cd8de7887c85e38ed029380c9e0bbf076d"
# which corresponds to:
# rx: "6c398fa11543400a10c1934fb2a28b3f39f78bd87a2d13a060987f39a094c691"
# s: "d82dbd95a20628a376fb337603cbb1cd8de7887c85e38ed029380c9e0bbf076d"
# id (message hash): "d2a97d43cd09bc89c97b77d3555a5c72a8650ca86605cbd4b663dc3d412048fa"
scarb cairo-run [0x6c398fa11543400a10c1934fb2a28b3f39f78bd87a2d13a060987f39a094c691, 0xd82dbd95a20628a376fb337603cbb1cd8de7887c85e38ed029380c9e0bbf076d, 0xd2a97d43cd09bc89c97b77d3555a5c72a8650ca86605cbd4b663dc3d412048fa]
