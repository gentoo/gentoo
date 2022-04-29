# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP keys used by the WeeChat project"
HOMEPAGE="https://www.weechat.org/"
# see https://weechat.org/download/
SRC_URI="
	https://keys.openpgp.org/vks/v1/by-fingerprint/A9AB5AB778FA5C3522FD0378F82F4B16DEC408F8
		-> weechat-A9AB5AB778FA5C3522FD0378F82F4B16DEC408F8.asc
"
S=${WORKDIR}

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

src_install() {
	local files=( ${A} )
	insinto /usr/share/openpgp-keys
	newins - weechat.org.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}
