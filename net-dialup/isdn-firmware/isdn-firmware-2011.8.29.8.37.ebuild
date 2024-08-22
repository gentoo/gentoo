# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit rpm

MY_PN="i4lfirm"
MY_PV="$(ver_cut 1-3)"
MY_PP="lp152.$(ver_cut 4-)"
MY_P="${MY_PN}-${MY_PV}-${MY_PP}"

DESCRIPTION="ISDN firmware for active ISDN cards (AVM, Eicon, etc.)"
HOMEPAGE="https://www.isdn4linux.de/"
SRC_URI="https://rsync.opensuse.org/distribution/leap/15.2/repo/oss/x86_64/${MY_P}.x86_64.rpm"

LICENSE="freedist"		#446158
SLOT="0"
KEYWORDS="amd64 ppc x86"

# Bug #827318
BDEPEND="app-arch/xz-utils[extra-filters(+)]"

S="${WORKDIR}/lib/firmware/isdn"

src_install() {
	insinto $(get_libdir)/firmware
	insopts -m 0644
	doins *
}
