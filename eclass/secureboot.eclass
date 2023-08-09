# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: secureboot.eclass
# @MAINTAINER:
# Andrew Ammerlaan <andrewammerlaan@gentoo.org>
# @AUTHOR:
# Author: Andrew Ammerlaan <andrewammerlaan@gentoo.org>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: A small eclass to sign efi files for Secure Boot
# @DESCRIPTION:
# Eclass for packages that install .efi files. A use flag and two user
# variables allow signing these .efi files for use on systems with Secure Boot
# enabled.
#
# Signing the files during emerge ensures that any tooling that actually
# installs the bootloaders and kernels to ESP always uses a signed version.
# This prevents Secure Boot from accidentally breaking when upgrading the
# kernel or the bootloader.
#
# Example use
# @CODE
# src_install() {
# 	default
# 	secureboot_sign_efi_file in.efi out.efi.signed
# }
# @CODE
#
# Or
# @CODE
# src_install() {
# 	default
# 	secureboot_auto_sign
# }
# @CODE
#
# Some tools will automatically detect and use EFI executables with the .signed
# suffix. For tools that do not do this the --in-place argument for
# secureboot_auto_sign can be used to ensure that the signed version is used.

case ${EAPI} in
	7|8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

IUSE="secureboot"
BDEPEND="secureboot? ( app-crypt/sbsigntools )"

# @ECLASS_VARIABLE: SECUREBOOT_SIGN_KEY
# @USER_VARIABLE
# @DEFAULT_UNSET
# @DESCRIPTION:
# Used with USE=secureboot.  Should be set to the path of the private
# key in PEM format to use, or a PKCS#11 URI.
#
# @ECLASS_VARIABLE: SECUREBOOT_SIGN_CERT
# @USER_VARIABLE
# @DEFAULT_UNSET
# @DESCRIPTION:
# Used with USE=secureboot.  Should be set to the path of the public
# key certificate in PEM format to use.

if [[ -z ${_SECUREBOOT_ECLASS} ]]; then
_SECUREBOOT_ECLASS=1

# @FUNCTION: _secureboot_die_if_unset
# @INTERNAL
# @DESCRIPTION:
# If USE=secureboot is enabled die if the required user variables are unset
# and die if the keys can't be found.
_secureboot_die_if_unset() {
	debug-print-function ${FUNCNAME[0]} "${@}"
	use secureboot || return

	if [[ -z ${SECUREBOOT_SIGN_KEY} || -z ${SECUREBOOT_SIGN_CERT} ]]; then
		die "USE=secureboot enabled but SECUREBOOT_SIGN_KEY and/or SECUREBOOT_SIGN_CERT not set."
	fi
	if [[ ! ${SECUREBOOT_SIGN_KEY} == pkcs11:* && ! -f ${SECUREBOOT_SIGN_KEY} ]]; then
		die "SECUREBOOT_SIGN_KEY=${SECUREBOOT_SIGN_KEY} not found"
	fi
	if [[ ! -f ${SECUREBOOT_SIGN_CERT} ]];then
		die "SECUREBOOT_SIGN_CERT=${SECUREBOOT_SIGN_CERT} not found"
	fi
}

# @FUNCTION: secureboot_pkg_setup
# @DESCRIPTION:
# Checks if required user variables are set before starting the build
secureboot_pkg_setup() {
	debug-print-function ${FUNCNAME[0]} "${@}"
	use secureboot || return

	# If we are merging a binary then the files in this binary
	# are already signed, no need to check the variables.
	if [[ ${MERGE_TYPE} != binary ]]; then
		_secureboot_die_if_unset
	fi
}

# @FUNCTION: secureboot_sign_efi_file
# @USAGE: <input file> <output file>
# @DESCRIPTION:
# Sign a file using sbsign and the requested key/certificate.
# If the file is already signed with our key then skip.
secureboot_sign_efi_file() {
	debug-print-function ${FUNCNAME[0]} "${@}"
	use secureboot || return

	local input_file=${1}
	local output_file=${2}

	_secureboot_die_if_unset

	ebegin "Signing ${input_file}"
	local return=1
	if sbverify "${input_file}" --cert "${SECUREBOOT_SIGN_CERT}" &> /dev/null; then
		ewarn "${input_file} already signed, skipping"
		return=0
	else
		local args=(
			"--key=${SECUREBOOT_SIGN_KEY}"
			"--cert=${SECUREBOOT_SIGN_CERT}"
		)
		if [[ ${SECUREBOOT_SIGN_KEY} == pkcs11:* ]]; then
			args+=( --engine=pkcs11 )
		fi

		sbsign "${args[@]}" "${input_file}" --output "${output_file}"
		return=${?}
	fi
	eend ${return} || die "Signing ${input_file} failed"
}

# @FUNCTION: secureboot_auto_sign
# @USAGE: [--in-place]
# @DESCRIPTION:
# Automatically discover and sign efi files in the image directory.
#
# By default signed files gain the .signed suffix. If the --in-place
# argument is given the efi files are replaced with a signed version in place.
secureboot_auto_sign() {
	debug-print-function ${FUNCNAME[0]} "${@}"
	use secureboot || return

	[[ ${EBUILD_PHASE} == install ]] ||
		die "${FUNCNAME[0]} can only be called in the src_install phase"

	local -a efi_execs
	mapfile -td '' efi_execs < <(
		find "${ED}" -type f \
			\( -iname '*.efi' -o -iname '*.efi32' -o -iname '*.efi64' \) \
			-print0 || die
	)
	(( ${#efi_execs[@]} )) ||
		die "${FUNCNAME[0]} was called but no efi executables were found"

	local suffix
	if [[ ${1} == --in-place ]]; then
		suffix=""
	elif [[ -n ${1} ]]; then
		die "Invalid argument ${1}"
	else
		suffix=".signed"
	fi

	for efi_exec in "${efi_execs[@]}"; do
		secureboot_sign_efi_file "${efi_exec}" "${efi_exec}${suffix}"
	done
}

fi

EXPORT_FUNCTIONS pkg_setup
