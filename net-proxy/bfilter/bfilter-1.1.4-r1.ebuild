# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-proxy/bfilter/bfilter-1.1.4-r1.ebuild,v 1.7 2014/01/08 06:23:50 vapier Exp $

EAPI=4

inherit eutils autotools user

DESCRIPTION="An ad-filtering web proxy featuring an effective heuristic ad-detection algorithm"
HOMEPAGE="http://bfilter.sourceforge.net/"
SRC_URI="mirror://sourceforge/bfilter/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="X debug"

RDEPEND="sys-libs/zlib
	dev-libs/ace
	dev-libs/libsigc++:2
	X? ( dev-cpp/gtkmm:2.4 x11-libs/libX11 )
	dev-libs/boost"

DEPEND="${RDEPEND}
	dev-util/scons
	virtual/pkgconfig"

RESTRICT="test" # boost's test API has changed

src_prepare() {
	epatch "${FILESDIR}"/${P}-glib-2.32.patch
	epatch "${FILESDIR}"/${P}-external-boost.patch
	epatch "${FILESDIR}"/${P}-gtkmm-X11-underlinking.patch

	rm -rf "${S}"/boost
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable debug) \
		$(use_with X gui) \
		--without-builtin-boost
}

src_install() {
	emake DESTDIR="${D}" install
	insinto /etc/bfilter
	doins "${FILESDIR}"/forwarding.xml

	dodoc AUTHORS ChangeLog "${FILESDIR}"/forwarding-proxy.xml
	dohtml doc/*

	newinitd "${FILESDIR}/bfilter.init" bfilter
	newconfd "${FILESDIR}/bfilter.conf" bfilter
}

pkg_preinst() {
	enewgroup bfilter
	enewuser bfilter -1 -1 -1 bfilter
}

pkg_postinst() {
	elog "The documentation is available at"
	elog "   http://bfilter.sourceforge.net/documentation.php"
	elog "For forwarding bfilter service traffic through a proxy,"
	elog "see forwarding-proxy.xml example installed in the doc directory."
}
