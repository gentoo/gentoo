# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: secureboot.eclass
# @MAINTAINER:
# Nowa Ammerlaan <nowa@gentoo.org>
# @AUTHOR:
# Author: Nowa Ammerlaan <nowa@gentoo.org>
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
BDEPEND="
	secureboot? (
		app-crypt/sbsigntools
		dev-libs/openssl
	)
"

# @ECLASS_VARIABLE: SECUREBOOT_SIGN_KEY
# @USER_VARIABLE
# @DEFAULT_UNSET
# @DESCRIPTION:
# Used with USE=secureboot.  Should be set to the path of the private
# key in PEM format to use, or a PKCS#11 URI.
# If unspecified the following locations are tried in order:
# - /etc/portage/secureboot.pem
# - /var/lib/sbctl/keys/db/db.{key,pem} (from app-crypt/sbctl)
# - the MODULES_SIGN_KEY (and MODULES_SIGN_CERT if set)
# - the contents of CONFIG_MODULE_SIG_KEY in the current kernel
# If none of these exist, a new key will be generated at
# /etc/portage/secureboot.pem.

# @ECLASS_VARIABLE: SECUREBOOT_SIGN_CERT
# @USER_VARIABLE
# @DEFAULT_UNSET
# @DESCRIPTION:
# Used with USE=secureboot.  Should be set to the path of the public
# key certificate in PEM format to use.
# If unspecified the SECUREBOOT_SIGN_KEY is assumed to also contain the
# certificate belonging to it.

if [[ -z ${_SECUREBOOT_ECLASS} ]]; then
_SECUREBOOT_ECLASS=1

inherit linux-info

# @FUNCTION: secureboot_pkg_setup
# @DESCRIPTION:
# Checks if required user variables are set before starting the build
secureboot_pkg_setup() {
	debug-print-function ${FUNCNAME} "$@"
	use secureboot || return

	# If we are merging a binary then the files in this binary
	# are already signed, no need to check the variables.
	if [[ ${MERGE_TYPE} != binary ]]; then
		if [[ -z ${SECUREBOOT_SIGN_KEY} ]]; then
			# No key specified, try some usual suspects
			linux-info_pkg_setup
			local module_sig_key=
			if linux_config_exists MODULE_SIG_KEY; then
				: "$(linux_chkconfig_string MODULE_SIG_KEY)"
				module_sig_key=${_//\"}
				# Convert to absolute path if required
				if [[ ${module_sig_key} != pkcs11:* &&
					${module_sig_key} != /* ]]
				then
					module_sig_key=${KV_OUT_DIR}/${module_sig_key}
				fi
			fi

			# Check both the SYSROOT and ROOT, like linux-info.eclass
			ewarn "No Secure Boot signing key specified."
			if [[ -r ${SYSROOT}/etc/portage/secureboot.pem ]]; then
				ewarn "Using ${SYSROOT}/etc/portage/secureboot.pem as signing key"
				export SECUREBOOT_SIGN_KEY=${SYSROOT}/etc/portage/secureboot.pem
				export SECUREBOOT_SIGN_CERT=${SYSROOT}/etc/portage/secureboot.pem
			elif [[ -r ${ROOT}/etc/portage/secureboot.pem ]]; then
				ewarn "Using ${ROOT}/etc/portage/secureboot.pem as signing key"
				export SECUREBOOT_SIGN_KEY=${ROOT}/etc/portage/secureboot.pem
				export SECUREBOOT_SIGN_CERT=${ROOT}/etc/portage/secureboot.pem
			elif [[ -r ${SYSROOT}/var/lib/sbctl/keys/db/db.key &&
				-r ${SYSROOT}/var/lib/sbctl/keys/db/db.pem ]]
			then
				ewarn "Using keys maintained by app-crypt/sbctl"
				export SECUREBOOT_SIGN_KEY=${SYSROOT}/var/lib/sbctl/keys/db/db.key
				export SECUREBOOT_SIGN_CERT=${SYSROOT}/var/lib/sbctl/keys/db/db.pem
			elif [[ -r ${ROOT}/var/lib/sbctl/keys/db/db.key &&
				-r ${ROOT}/var/lib/sbctl/keys/db/db.pem ]]
			then
				ewarn "Using keys maintained by app-crypt/sbctl"
				export SECUREBOOT_SIGN_KEY=${ROOT}/var/lib/sbctl/keys/db/db.key
				export SECUREBOOT_SIGN_CERT=${ROOT}/var/lib/sbctl/keys/db/db.pem
			elif [[ -r ${MODULES_SIGN_KEY} ]]; then
				ewarn "Using the kernel module signing key"
				export SECUREBOOT_SIGN_KEY=${MODULES_SIGN_KEY}
				if [[ -r ${MODULES_SIGN_CERT} ]]; then
					export SECUREBOOT_SIGN_CERT=${MODULES_SIGN_CERT}
				else
					export SECUREBOOT_SIGN_CERT=${MODULES_SIGN_KEY}
				fi
			elif [[ -r ${KV_OUT_DIR}/certs/signing_key.x509 ]] &&
				[[ -r ${module_sig_key} || ${module_sig_key} == pkcs11:* ]]
			then
				ewarn "Using keys maintained by the kernel"
				openssl x509 \
					-in "${KV_OUT_DIR}/certs/signing_key.x509" -inform DER \
					-out "${T}/secureboot.pem" -outform PEM ||
						die "Failed to convert kernel certificate to PEM format"
				export SECUREBOOT_SIGN_KEY=${module_sig_key}
				export SECUREBOOT_SIGN_CERT=${T}/secureboot.pem
			else
				ewarn "No candidate keys found, generating a new key"
				local openssl_gen_args=(
					req -new -batch -nodes -utf8 -sha256 -days 36500 -x509
					-outform PEM -out "${SYSROOT}/etc/portage/secureboot.pem"
					-keyform PEM -keyout "${SYSROOT}/etc/portage/secureboot.pem"
					)
				if [[ -r ${KV_OUT_DIR}/certs/x509.genkey ]]; then
					openssl_gen_args+=(
						-config "${KV_OUT_DIR}/certs/x509.genkey"
					)
				elif [[ -r ${KV_OUT_DIR}/certs/default_x509.genkey ]]; then
					openssl_gen_args+=(
						-config "${KV_OUT_DIR}/certs/default_x509.genkey"
					)
				else
					openssl_gen_args+=(
						-subj '/CN=Build time autogenerated kernel key'
					)
				fi
				(
					umask 066
					openssl "${openssl_gen_args[@]}" ||
						die "Failed to generate new signing key"
					# Generate DER format key as well for easy inclusion in
					# either the UEFI dB or MOK list.
					openssl x509 \
						-in "${SYSROOT}/etc/portage/secureboot.pem" -inform PEM \
						-out "${ROOT}/etc/portage/secureboot.x509" -outform DER ||
							die "Failed to convert signing certificate to DER format"
				)
				export SECUREBOOT_SIGN_KEY=${SYSROOT}/etc/portage/secureboot.pem
				export SECUREBOOT_SIGN_CERT=${SYSROOT}/etc/portage/secureboot.pem
			fi
		elif [[ -z ${SECUREBOOT_SIGN_CERT} ]]; then
			ewarn "A SECUREBOOT_SIGN_KEY was specified but no SECUREBOOT_SIGN_CERT"
			ewarn "was set. Assuming the certificate is in the same file as the key."
			export SECUREBOOT_SIGN_CERT=${SECUREBOOT_SIGN_KEY}
		fi

		# Sanity check: fail early if key/cert in DER format or does not exist
		local openssl_args=(
			-inform PEM -in "${SECUREBOOT_SIGN_CERT}"
			-noout -nocert
		)
		if [[ ${SECUREBOOT_SIGN_KEY} == pkcs11:* ]]; then
			openssl_args+=( -engine pkcs11 -keyform ENGINE -key "${SECUREBOOT_SIGN_KEY}" )
		else
			openssl_args+=( -keyform PEM -key "${SECUREBOOT_SIGN_KEY}" )
		fi

		openssl x509 "${openssl_args[@]}" ||
			die "Secure Boot signing certificate or key not found or not PEM format."
	fi
}

# @FUNCTION: secureboot_sign_efi_file
# @USAGE: <input file> [<output file>]
# @DESCRIPTION:
# Sign a file using sbsign and the requested key/certificate.
# If the file is already signed with our key then the file is skipped.
# If no output file is specified the output file will be the same
# as the input file, i.e. the file will be overwritten.
secureboot_sign_efi_file() {
	debug-print-function ${FUNCNAME} "$@"
	use secureboot || return

	local input_file=${1}
	local output_file=${2:-${1}}

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
	debug-print-function ${FUNCNAME} "$@"
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
