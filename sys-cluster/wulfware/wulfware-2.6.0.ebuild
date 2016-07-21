# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit autotools eutils multilib toolchain-funcs

DESCRIPTION="Applications to monitor on a beowulf- or GRID-style clusters"
HOMEPAGE="http://www.phy.duke.edu/~rgb/Beowulf/wulfware.php"
SRC_URI="http://www.phy.duke.edu/~rgb/Beowulf/${PN}/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-libs/libxml2
	sys-libs/ncurses
	sys-libs/zlib"
DEPEND="${RDEPEND}
	!sys-cluster/wulfstat
	!sys-cluster/xmlsysd"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-opts_and_strip.patch
	eautoreconf
}

src_compile() {
	tc-export CC
	econf --disable-dependency-tracking
	emake -j1 || die "emake failed."
}

src_install() {
	emake prefix="${D}/usr" libdir="${D}/usr/$(get_libdir)" \
		includedir="${D}/usr/include" sysconfdir="${D}/etc" \
		install || die "emake install failed."

	dodoc AUTHORS ChangeLog NEWS NOTES README xmlsysd/DESIGN

	# FIXME: Update to Gentoo style init script.
	rm -rf "${D}"/etc/init.d/wulf2html
}

pkg_postinst() {
	elog "Add following line to /etc/services if you haven't done so already:"
	elog
	elog "xmlsysd       7887/tcp    # xmlsysd remote system stats"
	elog
	elog "Be sure to edit /etc/xinetd.d/xmylsysd to suit your own options."
}
