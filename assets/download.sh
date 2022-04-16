#!/bin/sh

set -e

HERE="$(dirname "$(readlink -e "$0")")"

IPFS_GATEWAY=${IPFS_GATEWAY:-dweb.link}

CACHEDIR="$HERE/cache"

mkdir -p "$CACHEDIR"

fail()
{
    echo "$@" >&2
    exit 1
}

check_hash()
{
    # $1 = filename
    # $2 = hash
    echo "$2 $1" | sha256sum -c - > /dev/null 2>&1
}

download_and_check()
{
    # $1 = url
    # $2 = filename
    # $3 = hash
    # $4 = name

    output_filename="$CACHEDIR/$2"

    if ! check_hash "$output_filename" "$3" ; then
        echo "Downloading $4..."
        curl --fail -o "$output_filename" "$1"
    else
        return 0
    fi

    check_hash "$output_filename" "$3"
}

download_and_check \
    "https://bafybeibdg5vpsldsfuvemdk4wfi6es46noxnbg6pjxjsmb27tr6g74wmfq.ipfs.${IPFS_GATEWAY}" \
    "bf1942_lnxded-1.6-rc2.run" \
    "ca6e754a028e8d12a4f3efbbc90892d979035be7d144de1f64d99884902568f3" \
    "Battlefield 1942 1.6-RC2 Server"

download_and_check \
    "https://bafybeie7463ofgnn2dhcxwqd7zvkyrv24mn4suose55aahlm74oq7z3nw4.ipfs.${IPFS_GATEWAY}" \
    "bf1942-update-1.61.tar.gz" \
    "6c60b6af994fba9e98f8e3a20ca04602f6f0ad2b40b4c549441918217bc02160" \
    "Battlefield 1942 1.61 Server Update"

download_and_check \
    "https://bafybeibollu6k4ohvq2skxs7gi3icwcfdc2gtzfiipegnnbueoqbl7dvv4.ipfs.${IPFS_GATEWAY}" \
    "bf1942_lnxded_1.612_patched_20220223.zip" \
    "bf148b1f96532659bcb6a031acd5d6196e1695f30c3660274cec3502272a5fd6" \
    "Battlefield 1942 Unofficial 1.612 20220223 Server Update"

download_and_check \
    "https://bafybeigywayklerwqrvyvgj7ghpxcdjfguvum3qjfowrhsty633vhnb4za.ipfs.${IPFS_GATEWAY}" \
    "all-server-maps.zip" \
    "2097d85b492b40d4dcc78bff160e4b9fb2b2d2d052c0cdc9ce8c1cb328c643f0" \
    "Maps from Doubti/Mourits"

download_and_check \
    "https://bafkreidfghfktrq2oqf7dvuf5q3k3wk3iouesbgqoacdz7nnyai46zq6re.ipfs.${IPFS_GATEWAY}" \
    "BFServerManager201.tgz" \
    "6531caa9c61a740bf1d685ec36add95b43a84904d070043cfdadc011cf661e89" \
    "Battlefield 1942 Server Manager 2.01"

# See https://team-simple.org/forum/viewtopic.php?id=6454
download_and_check \
    "https://bafkreiaydjtt3aj5f2da37vubmga26xuvwlzxoko5wj76kk47frwjfo4ce.ipfs.${IPFS_GATEWAY}" \
    "bfsmd.internal_err_patched" \
    "181a673d813d2e860dfeb40b0c0d7af4ad979bb94eed93ff295cf9636495dc11" \
    "BFSM Internal Error! Patch by petr8"

download_and_check \
    "https://bafybeibflamy7qp3ufu32hj3dsh52cqnbkyph2kdjhf3mw35o4sbtkpnom.ipfs.${IPFS_GATEWAY}" \
    "pb-linuxserver-files.rar" \
    "7809d5886e374a3cf94b7702b8693c94d25d9989737e07b17c59cf5445119d16" \
    "Punkbuster Fix by BF-League"

download_and_check \
    "https://bafybeicaaa7pozguhjiwbx3i32ad32gqceiv2rpmvztps765nrbieaaatu.ipfs.${IPFS_GATEWAY}" \
    "desertcombat_0.7n-beta_full_install.run" \
    "0360036f3fd7ecc3c620e6ba51eebefb0b1ebab7d042bafb66f9d1af54d786a9" \
    "Desert Combat 0.7n Beta Server Files"

download_and_check \
    "https://bafybeiahwilwejgvmm5te3cs4fmh3chkh2drflhspm4jqqpoq3n6aihnhy.ipfs.${IPFS_GATEWAY}" \
    "dc_final_server.run" \
    "fceae8dc30c2ff79ec017b910115639c2df877d362bfa00b45b7be910d0ee052" \
    "Desert Combat Final Beta Server Files"

exit 0
