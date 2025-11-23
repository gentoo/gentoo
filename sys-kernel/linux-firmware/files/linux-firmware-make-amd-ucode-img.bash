#!/usr/bin/env bash

# Copyright 2024 Gentoo Authors

our_name=${0}
out=${1}
in=${2}

# familiar helpers, we intentionally don't use Gentoo functions.sh
die() {
    echo -e " ${NOCOLOR-\e[1;31m*\e[0m }${*}" >&2
    exit 1
}

einfo() {
    echo -e " ${NOCOLOR-\e[1;32m*\e[0m }${*}" >&2
}

main() {
    # re-define for subst to work
    [[ -n ${NOCOLOR+yes} ]] && NOCOLOR=


    # Set the output file to arg 1 if it's not a directory.
    # If it's a directory, set the out file to the directory with the default name.
    # If it's a relative filename, include it in the variable.
    local ucode_file=${out:-"/boot/amd-uc.img"}
    if [[ -d ${ucode_file} ]]; then
        ucode_file="${ucode_file}/amd-uc.img"
        einfo "Output file is a directory. Using default name: ${ucode_file}"
    elif [[ ${ucode_file} != /* ]]; then
        ucode_file="$(pwd)/${ucode_file}"
        einfo "Output file is a relative path. Using full path: ${ucode_file}"
    elif [[ -z ${ucode_file} ]]; then
        einfo "Usage: ${our_name} <output image> <microcode directory>"
        die "No output file specified"
    fi

    # Only AMD microcode is in the linux-firmmware package
    local ucode_dir=${in:-"/lib/firmware/amd-ucode"}
    if [[ ! -d ${ucode_dir} ]]; then
        einfo "Usage: ${our_name} <output image> <microcode directory>"
        die "AMD microcode directory does not exist: ${ucode_dir}"
    fi

    # Make the tmp dir for the microcode archive
    local ucode_tmp_dir="$(mktemp -d)" || die "Failed to create temporary directory"
    einfo "Created temporary directory: ${ucode_tmp_dir}"
    local ucode_bin_dir="${ucode_tmp_dir}/kernel/x86/microcode"
    local ucode_bin_file="${ucode_bin_dir}/AuthenticAMD.bin"

    # Write "1" to the early_cpio flag file
    echo 1 > "${ucode_tmp_dir}/early_cpio" || die

    # Make the directory for the microcode bin files
    mkdir -p "${ucode_bin_dir}" || die "Failed to create microcode bin directory: ${ucode_bin_dir}"

    # Concatenate all microcode bin files into a single file
    cat "${ucode_dir}"/*.bin > "${ucode_bin_file}" || die "Failed to concatenate microcode files into: ${ucode_bin_file}"

    # Check that the concatenated file is not empty
    [[ -s "${ucode_bin_file}" ]] || die "Empty microcode file: ${ucode_bin_file}"

    pushd "${ucode_tmp_dir}" &> /dev/null || die
    # Create the cpio archive
    find . -print0 | cpio --quiet --null -o -H newc -R 0:0 > "${ucode_file}" || die "Failed to create microcode archive in: ${ucode_file}"
    popd &> /dev/null || die

    # Check that the cpio archive is not empty
    [[ -s "${ucode_file}" ]] || die "Empty microcode archive at: ${ucode_file}"

    einfo "Created microcode archive at: ${ucode_file}"
    # Clean up the tmp dir
    rm -r "${ucode_tmp_dir}" || die "Failed to remove temporary directory: ${ucode_tmp_dir}"
    einfo "Cleaned up temporary directory: ${ucode_tmp_dir}"
}

main

