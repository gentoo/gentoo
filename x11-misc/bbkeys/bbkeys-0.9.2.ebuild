# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

MY_PV="rel-$(ver_cut 1)$(ver_cut 2)$(ver_cut 3)"

DESCRIPTION="Use keyboard shortcuts in the blackbox wm"
HOMEPAGE="http://bbkeys.sourceforge.net"
SRC_URI="https://github.com/bbidulock/bbkeys/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="
	>=x11-wm/blackbox-0.70.0
	x11-libs/libXext
	x11-libs/libXft
	x11-libs/libX11
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/${PN}-${MY_PV}"

src_prepare() {
	sed -i -e '/^bbkeys_LDADD/ s#/usr/lib/libbt.a#-lbt#' src/Makefile.am || die
	default
	eautoreconf
}

src_install() {
	default
	rm -rf "${ED}"/usr/share/doc || die

	echo PRELINK_PATH_MASK=\""${EPREFIX}"/usr/bin/bbkeys\" > "${T}"/99bbkeys || die
	doenvd "${T}"/99bbkeys
}
