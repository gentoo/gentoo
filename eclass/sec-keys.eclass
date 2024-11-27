# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: sec-keys.eclass
# @MAINTAINER:
# Eli Schwartz <eschwartz@gentoo.org>
# @AUTHOR:
# Eli Schwartz <eschwartz@gentoo.org>
# @SUPPORTED_EAPIS: 8
# @BLURB: Provides a uniform way of handling ebuilds which package PGP key material
# @DESCRIPTION:
# This eclass provides a streamlined approach to finding suitable source
# material for OpenPGP keys used by the verify-sig eclass.  Its primary
# purpose is to permit developers to easily and securely package new
# sec-keys/* packages.  The eclass removes the risk of developers
# accidentally packaging malformed key material, or neglecting to
# notice when PGP identities have changed.
#
# To use the eclass, define SEC_KEYS_VALIDPGPKEYS to contain the
# fingerprint of the key and the short name of the key's owner.
#
# @EXAMPLE:
# Example use:
#
# @CODE
# SEC_KEYS_VALIDPGPKEYS=(
#	'3DB7F3CA6C1D90B99FE25B38D4B476A4D175C54F:bjones:ubuntu'
#	'4EC8A4DB7D2E01C00AF36C49E5C587B5E286C65A:jsmith:github,openpgp'
#	# key only available on personal website, use manual SRC_URI
#	'5FD9B5EC8E3F12D11BA47D50F6D698C6F397D76B:awhite:manual'
# )
#
# inherit sec-keys
#
# SRC_URI+="https://awhite.com/awhite.gpg -> awhite-${PV}.gpg"
# @CODE

case ${EAPI} in
	8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ ! ${_SEC_KEYS_ECLASS} ]]; then
_SEC_KEYS_ECLASS=1

inherit eapi9-pipestatus edo

# @ECLASS_VARIABLE: SEC_KEYS_VALIDPGPKEYS
# @PRE_INHERIT
# @DEFAULT_UNSET
# @DESCRIPTION:
# Mapping of fingerprints, name, and optional locations of PGP keys to
# include, separated by colons.  The allowed values for a location are:
#
#  - gentoo -- fetch key by fingerprint from https://keys.gentoo.org
#
#  - github -- fetch key from github.com/${name}.pgp
#
#  - openpgp -- fetch key by fingerprint from https://keys.openpgp.org
#
#  - ubuntu -- fetch key by fingerprint from http://keyserver.ubuntu.com
#
#  - manual -- do not add to SRC_URI, the ebuild will provide a custom
#    download location
_sec_keys_set_globals() {
	local key fingerprint name loc locations=() remote

	for key in "${SEC_KEYS_VALIDPGPKEYS[@]}"; do
		fingerprint=${key%%:*}
		name=${key#${fingerprint}:}; name=${name%%:*}
		IFS=, read -r -a locations <<<"${key##*:}"
		[[ ${locations[@]} ]] || die "${ECLASS}: ${name}: PGP key remote is mandatory"
		for loc in "${locations[@]}"; do
			case ${loc} in
				gentoo) remote="https://keys.gentoo.org/pks/lookup?op=get&search=0x${fingerprint}";;
				github) remote="https://github.com/${name}.gpg";;
				openpgp) remote="https://keys.openpgp.org/vks/v1/by-fingerprint/${fingerprint}";;
				ubuntu) remote="https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x${fingerprint}";;
				# provided via manual SRC_URI
				manual) continue;;
				*) die "${ECLASS}: unknown PGP key remote: ${loc}";;
			esac
			SRC_URI+="
				${remote} -> openpgp-keys-${name}-${loc}-${PV}.asc
			"
		done
	done
}
_sec_keys_set_globals
unset -f _sec_keys_set_globals

S=${WORKDIR}

LICENSE="public-domain"
SLOT="0"

IUSE="test"
PROPERTIES="test_network"
RESTRICT="!test? ( test )"

BDEPEND="
	app-crypt/gnupg
	test? ( app-crypt/pgpdump )
"



# @FUNCTION: sec-keys_src_compile
# @DESCRIPTION:
# Default src_compile override that:
#
# - imports all public keys into a keyring
#
# - validates that they are listed in SEC_KEYS_VALIDPGPKEYS
#
# - minifies and exports them back into a unified keyfile
sec-keys_src_compile() {
	local -x GNUPGHOME=${WORKDIR}/gnupg
	local fingerprint
	local gpg_command=(gpg --export-options export-minimal)

	mkdir -m700 -p "${GNUPGHOME}" || die
	cat <<- EOF > "${GNUPGHOME}"/gpg.conf || die
	no-secmem-warning
	EOF

	pushd "${DISTDIR}" >/dev/null || die
	gpg --import ${A} || die
	popd >/dev/null || die

	local line imported_keys=() found=0
	while IFS=: read -r -a line; do
		if [[ ${line[0]} = pub ]]; then
			# new key
			found=0
		elif [[ ${found} = 0 && ${line[0]} = fpr ]]; then
			# primary fingerprint
			imported_keys+=("${line[9]}")
			found=1
		fi
	done < <(gpg --batch --list-keys --with-colons || die)

	printf '%s\n' "${imported_keys[@]}" | sort > imported_keys.list || die
	printf '%s\n' "${SEC_KEYS_VALIDPGPKEYS[@]%%:*}" | sort > allowed_keys.list || die

	local extra_keys=($(comm -23 imported_keys.list allowed_keys.list || die))
	local missing_keys=($(comm -13 imported_keys.list allowed_keys.list || die))

	if [[ ${#extra_keys[@]} != 0 ]]; then
		die "Too many keys found. Suspicious keys: ${extra_keys[@]}"
	fi
	if [[ ${#missing_keys[@]} != 0 ]]; then
		die "Too few keys found. Unavailable keys: ${missing_keys[@]}"
	fi

	for fingerprint in "${SEC_KEYS_VALIDPGPKEYS[@]%%:*}"; do
		local uids=()
		mapfile -t uids < <("${gpg_command[@]}" --list-key --with-colons ${fingerprint} | awk -F: '/^uid/{print $10}' || die)
		edo "${gpg_command[@]}" "${uids[@]/#/--comment=}" --export --armor "${fingerprint}" > "${fingerprint}.asc"
		cat ${fingerprint}.asc >> ${PN#openpgp-keys-}.asc || die
	done
}

sec-keys_src_test() {
	local -x GNUPGHOME=${WORKDIR}/gnupg
	local key fingerprint name server
	local gpg_command=(gpg --export-options export-minimal)

	# Best-effort attempt to check for updates. keyservers can and usually
	# do fail for weird reasons, (such as being unable to import a key
	# without a uid) as well as normal reasons, like the key being exclusive
	# to a different keyserver. this isn't a reason to fail src_test.
	for server in keys.gentoo.org keys.openpgp.org keyserver.ubuntu.com; do
		gpg --refresh-keys --keyserver "hkps://${server}"
	done
	for key in "${SEC_KEYS_VALIDPGPKEYS[@]}"; do
		if [[ ${key##*:} = *github* ]]; then
			name=${key#*:}; name=${name%%:*}
			wget -qO- https://github.com/${name}.gpg | gpg --import
			pipestatus || die
		fi
	done

	for fingerprint in "${SEC_KEYS_VALIDPGPKEYS[@]%%:*}"; do
		pgpdump "${fingerprint}.asc" > "${fingerprint}.pgpdump" || die

		"${gpg_command[@]}" --export "${fingerprint}" | pgpdump > "${fingerprint}.pgpdump.new"
		pipestatus || die

		diff -u "${fingerprint}.pgpdump" "${fingerprint}.pgpdump.new" || die "updates available for PGP key: ${fingerprint}"
	done

}

# @FUNCTION: sec-keys_src_install
# @DESCRIPTION:
# Default src_install override that installs an ascii-armored keyfile
# installed to the standard /usr/share/openpgp-keys.
sec-keys_src_install() {
	insinto /usr/share/openpgp-keys
	doins ${PN#openpgp-keys-}.asc
}

fi

EXPORT_FUNCTIONS src_compile src_test src_install
