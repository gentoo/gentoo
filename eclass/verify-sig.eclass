# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: verify-sig.eclass
# @MAINTAINER:
# Michał Górny <mgorny@gentoo.org>
# @SUPPORTED_EAPIS: 7
# @BLURB: Eclass to verify upstream signatures on distfiles
# @DESCRIPTION:
# verify-sig eclass provides a streamlined approach to verifying
# upstream signatures on distfiles.  Its primary purpose is to permit
# developers to easily verify signatures while bumping packages.
# The eclass removes the risk of developer forgetting to perform
# the verification, or performing it incorrectly, e.g. due to additional
# keys in the local keyring.  It also permits users to verify
# the developer's work.
#
# To use the eclass, start by packaging the upstream's key
# as app-crypt/openpgp-keys-*.  Then inherit the eclass, add detached
# signatures to SRC_URI and set VERIFY_SIG_OPENPGP_KEY_PATH.  The eclass
# provides verify-sig USE flag to toggle the verification.
#
# Example use:
# @CODE
# inherit verify-sig
#
# SRC_URI="https://example.org/${P}.tar.gz
#   verify-sig? ( https://example.org/${P}.tar.gz.sig )"
# BDEPEND="
#   verify-sig? ( app-crypt/openpgp-keys-example )"
#
# VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/example.asc
# @CODE

case "${EAPI:-0}" in
	0|1|2|3|4|5|6)
		die "Unsupported EAPI=${EAPI} (obsolete) for ${ECLASS}"
		;;
	7)
		;;
	*)
		die "Unsupported EAPI=${EAPI} (unknown) for ${ECLASS}"
		;;
esac

EXPORT_FUNCTIONS src_unpack

if [[ ! ${_VERIFY_SIG_ECLASS} ]]; then

IUSE="verify-sig"

BDEPEND="
	verify-sig? (
		app-crypt/gnupg
		>=app-portage/gemato-16
	)"

# @ECLASS-VARIABLE: VERIFY_SIG_OPENPGP_KEY_PATH
# @DEFAULT_UNSET
# @DESCRIPTION:
# Path to key bundle used to perform the verification.  This is required
# when using default src_unpack.  Alternatively, the key path can be
# passed directly to the verification functions.

# @ECLASS-VARIABLE: VERIFY_SIG_OPENPGP_KEYSERVER
# @DEFAULT_UNSET
# @DESCRIPTION:
# Keyserver used to refresh keys.  If not specified, the keyserver
# preference from the key will be respected.  If no preference
# is specified by the key, the GnuPG default will be used.

# @ECLASS-VARIABLE: VERIFY_SIG_OPENPGP_KEY_REFRESH
# @USER_VARIABLE
# @DESCRIPTION:
# Attempt to refresh keys via WKD/keyserver.  Set it to "yes"
# in make.conf to enable.  Note that this requires working Internet
# connection.
: ${VERIFY_SIG_OPENPGP_KEY_REFRESH:=no}

# @FUNCTION: verify-sig_verify_detached
# @USAGE: <file> <sig-file> [<key-file>]
# @DESCRIPTION:
# Read the detached signature from <sig-file> and verify <file> against
# it.  <key-file> can either be passed directly, or it defaults
# to VERIFY_SIG_OPENPGP_KEY_PATH.  The function dies if verification
# fails.
verify-sig_verify_detached() {
	local file=${1}
	local sig=${2}
	local key=${3:-${VERIFY_SIG_OPENPGP_KEY_PATH}}

	[[ -n ${key} ]] ||
		die "${FUNCNAME}: no key passed and VERIFY_SIG_OPENPGP_KEY_PATH unset"

	local extra_args=()
	[[ ${VERIFY_SIG_OPENPGP_KEY_REFRESH} == yes ]] || extra_args+=( -R )
	[[ -n ${VERIFY_SIG_OPENPGP_KEYSERVER+1} ]] && extra_args+=(
		--keyserver "${VERIFY_SIG_OPENPGP_KEYSERVER}"
	)

	# GPG upstream knows better than to follow the spec, so we can't
	# override this directory.  However, there is a clean fallback
	# to GNUPGHOME.
	addpredict /run/user

	local filename=${file##*/}
	[[ ${file} == - ]] && filename='(stdin)'
	einfo "Verifying ${filename} ..."
	gemato gpg-wrap -K "${key}" "${extra_args[@]}" -- \
		gpg --verify "${sig}" "${file}" ||
		die "PGP signature verification failed"
}

# @FUNCTION: verify-sig_src_unpack
# @DESCRIPTION:
# Default src_unpack override that verifies signatures for all
# distfiles if 'verify-sig' flag is enabled.  The function dies if any
# of the signatures fails to verify or if any distfiles are not signed.
# Please write src_unpack() yourself if you need to perform partial
# verification.
verify-sig_src_unpack() {
	if use verify-sig; then
		local f suffix found
		local distfiles=() signatures=() nosigfound=() straysigs=()

		# find all distfiles and signatures, and combine them
		for f in ${A}; do
			found=
			for suffix in .asc .sig; do
				if [[ ${f} == *${suffix} ]]; then
					signatures+=( "${f}" )
					found=sig
					break
				else
					if has "${f}${suffix}" ${A}; then
						distfiles+=( "${f}" )
						found=dist+sig
						break
					fi
				fi
			done
			if [[ ! ${found} ]]; then
				nosigfound+=( "${f}" )
			fi
		done

		# check if all distfiles are signed
		if [[ ${#nosigfound[@]} -gt 0 ]]; then
			eerror "The following distfiles lack detached signatures:"
			for f in "${nosigfound[@]}"; do
				eerror "  ${f}"
			done
			die "Unsigned distfiles found"
		fi

		# check if there are no stray signatures
		for f in "${signatures[@]}"; do
			if ! has "${f%.*}" "${distfiles[@]}"; then
				straysigs+=( "${f}" )
			fi
		done
		if [[ ${#straysigs[@]} -gt 0 ]]; then
			eerror "The following signatures do not match any distfiles:"
			for f in "${straysigs[@]}"; do
				eerror "  ${f}"
			done
			die "Unused signatures found"
		fi

		# now perform the verification
		for f in "${signatures[@]}"; do
			verify-sig_verify_detached \
				"${DISTDIR}/${f%.*}" "${DISTDIR}/${f}"
		done
	fi

	# finally, unpack the distfiles
	default_src_unpack
}

_VERIFY_SIG_ECLASS=1
fi
