# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP keys used by libuv"
HOMEPAGE="https://libuv.org/"

# See the following:
# - https://github.com/libuv/libuv/blob/v1.x/MAINTAINERS.md
# - https://github.com/libuv/libuv/issues/4306
# - https://github.com/libuv/libuv/issues/4307
#
# Most keys are uploaded to keyserver.ubuntu.com, some are not.
#
# Some keys at keyserver.ubuntu.com are not "registered", so no UID.
#
# Some keys are uploaded to github.com, some are not.
#
# Some keys at github.com are expired, despite owner having extended
# them locally and still using them.
#
# GitHub key export (/username.gpg) may include cruft comment lines
# which cause GPG to error during import.
#
# Most keys are stored within the git repo, but in a manner that cannot
# be fetched via https://github.com/, only by cloning the repo.
#
# Some of the keys stored in the repo are expired.
#
# Test for viability of sources:
#
# for key in $(egrep 'GPG key:' MAINTAINERS.md | sed 's/^ *- GPG key: //; s/ (pubkey.*//; s/ //g') ; do
#   echo -n "$key "
#   curl -s "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x${key}" | \
#   	egrep -q 'BEGIN PGP' && echo yes || echo no
# done
#
# for user in $(egrep -B1 'GPG key:' MAINTAINERS.md | sed -n -E 's/.*\*\* +\( *\[@([^] ]+)\].*/\1/p') ; do
#   echo -n "$user "
#   curl -s "https://github.com/${user}.gpg" | egrep -q '^mQ' && echo yes || echo no
# done
#
# Collect the yeses (keep dupes because some are not current) and then:
#
# for A in \
#		D77B1E34243FBAF05F8E9CC34F55C8C846AB89B9 \
#		AEAD0A4B686767751A0E4AEF34A25FB128246514 \
#		CFBB9CA9A5BEAFD70E2B3C5A79A67C55A3679C8B \
#		C82FA3AE1CBEDC6BE46B9360C43CEC45C17AB93C \
#		612F0EAD9401622379DF4402F28C3C8DA33C03BE \
#		FDF519364458319FA8233DC9410E5553AE9BC059 \
#		94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
#		57353E0DBDAAA7E839B66A1AFF47D5E4AD8B4FDC \
#		AF2EEA41EC3447BFDD86FED9D7063CCE19B7E890 \
#   ; do
#   echo -e "\t'https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x${A}\n\t\t-> libuv-\${PV}-${A}.asc"
# done
#
# for A in vtjnash richardlau santigimeno trevnorris cjihrig ; do
#   echo -e "\thttps://github.com/${A}.gpg\n\t\t-> libuv-\${PV}-${A}.asc"
# done

# XXXX: keyserver.ubuntu.com gives unstable results so we can't even get it mirrored
# as the result has already changed by that point.
#
#SRC_URI="
#	https://keyserver.ubuntu.com/pks/lookup?op=get&search=0xD77B1E34243FBAF05F8E9CC34F55C8C846AB89B9
#		-> libuv-${PV}-D77B1E34243FBAF05F8E9CC34F55C8C846AB89B9.asc
#	https://keyserver.ubuntu.com/pks/lookup?op=get&search=0xAEAD0A4B686767751A0E4AEF34A25FB128246514
#		-> libuv-${PV}-AEAD0A4B686767751A0E4AEF34A25FB128246514.asc
#	https://keyserver.ubuntu.com/pks/lookup?op=get&search=0xCFBB9CA9A5BEAFD70E2B3C5A79A67C55A3679C8B
#		-> libuv-${PV}-CFBB9CA9A5BEAFD70E2B3C5A79A67C55A3679C8B.asc
#	https://keyserver.ubuntu.com/pks/lookup?op=get&search=0xC82FA3AE1CBEDC6BE46B9360C43CEC45C17AB93C
#		-> libuv-${PV}-C82FA3AE1CBEDC6BE46B9360C43CEC45C17AB93C.asc
#	https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x612F0EAD9401622379DF4402F28C3C8DA33C03BE
#		-> libuv-${PV}-612F0EAD9401622379DF4402F28C3C8DA33C03BE.asc
#	https://keyserver.ubuntu.com/pks/lookup?op=get&search=0xFDF519364458319FA8233DC9410E5553AE9BC059
#		-> libuv-${PV}-FDF519364458319FA8233DC9410E5553AE9BC059.asc
#	https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x94AE36675C464D64BAFA68DD7434390BDBE9B9C5
#		-> libuv-${PV}-94AE36675C464D64BAFA68DD7434390BDBE9B9C5.asc
#	https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x57353E0DBDAAA7E839B66A1AFF47D5E4AD8B4FDC
#		-> libuv-${PV}-57353E0DBDAAA7E839B66A1AFF47D5E4AD8B4FDC.asc
#	https://keyserver.ubuntu.com/pks/lookup?op=get&search=0xAF2EEA41EC3447BFDD86FED9D7063CCE19B7E890
#		-> libuv-${PV}-AF2EEA41EC3447BFDD86FED9D7063CCE19B7E890.asc
#	https://github.com/vtjnash.gpg
#		-> libuv-${PV}-vtjnash.asc
#	https://github.com/richardlau.gpg
#		-> libuv-${PV}-richardlau.asc
#	https://github.com/santigimeno.gpg
#		-> libuv-${PV}-santigimeno.asc
#	https://github.com/trevnorris.gpg
#		-> libuv-${PV}-trevnorris.asc
#	https://github.com/cjihrig.gpg
#		-> libuv-${PV}-cjihrig.asc
#"

SRC_URI="
	https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/libuv-${PV}-D77B1E34243FBAF05F8E9CC34F55C8C846AB89B9.asc
	https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/libuv-${PV}-AEAD0A4B686767751A0E4AEF34A25FB128246514.asc
	https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/libuv-${PV}-CFBB9CA9A5BEAFD70E2B3C5A79A67C55A3679C8B.asc
	https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/libuv-${PV}-C82FA3AE1CBEDC6BE46B9360C43CEC45C17AB93C.asc
	https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/libuv-${PV}-612F0EAD9401622379DF4402F28C3C8DA33C03BE.asc
	https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/libuv-${PV}-FDF519364458319FA8233DC9410E5553AE9BC059.asc
	https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/libuv-${PV}-94AE36675C464D64BAFA68DD7434390BDBE9B9C5.asc
	https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/libuv-${PV}-57353E0DBDAAA7E839B66A1AFF47D5E4AD8B4FDC.asc
	https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/libuv-${PV}-AF2EEA41EC3447BFDD86FED9D7063CCE19B7E890.asc
	https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/libuv-${PV}-vtjnash.asc
	https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/libuv-${PV}-richardlau.asc
	https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/libuv-${PV}-santigimeno.asc
	https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/libuv-${PV}-trevnorris.asc
	https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/libuv-${PV}-cjihrig.asc
"

S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

src_compile() {
	local files=( ${A} )

	touch libuv.asc || die
	# Skip keys w/no UID (gpg will error and gemato will abort),
	# and strip github header (gpg will error and gemato will abort)
	local file
	for file in "${files[@]/#/${DISTDIR}/}" ; do
		if gpg --list-packets "${file}" 2>/dev/null | egrep -q '^:user ID' ; then
			sed "/^Note: The keys with the following IDs couldn't be exported/d" "${file}" >>libuv.asc || die
		fi
	done
}

src_install() {
	local files=( ${A} )
	insinto /usr/share/openpgp-keys
	doins libuv.asc
}
