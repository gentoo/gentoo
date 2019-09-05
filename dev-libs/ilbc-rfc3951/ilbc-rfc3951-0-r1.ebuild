# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="iLBC is a speech codec suitable for robust voice communication over IP"
HOMEPAGE="https://webrtc.org/license/ilbc-freeware/"
SRC_URI="http://simon.morlat.free.fr/download/1.1.x/source/ilbc-rfc3951.tar.gz -> ${P}.tar.gz"

# relicensed under 3-clause BSD license, bug 390797
LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 ~arm arm64 ~hppa ia64 ppc ppc64 sparc x86"

S="${WORKDIR}/${PN}"
PATCHES=( "${FILESDIR}"/${PN}-asneeded.patch )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--enable-shared \
		--disable-static
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
