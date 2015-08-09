# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
WX_GTK_VER="2.8"
inherit wxwidgets

MY_PN="iMule"

DESCRIPTION="P2P sharing software which connects through I2P and Kad networks"
# New homepage has a few resources and a working nodes.dat file users need
# in order to get iMule to work
HOMEPAGE="http://echelon.i2p/imule"
SRC_URI="http://dev.gentoo.org/~zlg/extra/net-p2p/imule/${MY_PN}-${PV}-src.tbz http://dev.gentoo.org/~zlg/extra/net-p2p/imule/2015-03-22_nodes.dat"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="webserver static-libs nls"
RESTRICT="mirror"

# wxGTK 2.8 is required; later versions result in failed compile
# Other versions indicated are from the tarball's INSTALL file
DEPEND="x11-libs/wxGTK:2.8
	net-p2p/i2p
	>=net-libs/libupnp-1.6.6
	sys-devel/flex
	sys-apps/texinfo
	>=dev-libs/crypto++-5.1
	!net-p2p/amule"
RDEPEND="x11-libs/wxGTK:2.8 net-p2p/i2p"

S="${WORKDIR}/${MY_PN}-${PV}-src"

src_unpack() {
	default
	cp "${DISTDIR}"/2015-03-22_nodes.dat "${WORKDIR}"
}

src_configure() {
	WX_GTK_VER="2.8" need-wxwidgets unicode
	# Enabling imulecmd results in a compilation error.
	econf --with-wx-config=${WX_CONFIG} \
		--enable-imule-daemon \
		--enable-alc \
		--enable-alcc \
		--enable-optimize \
		--disable-debug \
		$(use_enable nls) \
		$(use_enable webserver) \
		$(use_enable static-libs static)
}

src_install() {
	default
	insinto /usr/share/${PN}
	newins "${WORKDIR}"/2015-03-22_nodes.dat nodes.dat
}

pkg_postinst() {
	elog "iMule will not function without a valid 'nodes.dat' file and"
	elog "an I2P router running."
	elog "A nodes.dat file can be found in /usr/share/imule. It can"
	elog "be copied to ~/.iMule/nodes.dat for convenience."
}
