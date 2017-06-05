#!/bin/bash

while getopts "k:" opt; do
    case $opt in
        k)
            kms_key_id="$OPTARG"
            ;;

        \?)
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;

        :)
            echo "Option -$OPTARG requires an argument." >&2
            exit 1
            ;;
    esac
done

if [[ -z $kms_key_id ]]; then
    echo "Option -k (kms key ID) is required." >&2
    exit 1
fi

for name in wp_auth_key wp_secure_auth_key wp_logged_in_key wp_nonce_key wp_auth_salt wp_secure_auth_salt wp_logged_in_salt wp_nonce_salt; do
    secret="$(openssl rand -base64 128 | head -n1)"
    encrypted="$(aws kms encrypt --key-id "$kms_key_id" --output text --query CiphertextBlob --plaintext "$secret")"

    echo "$name = \"$encrypted\""
done
