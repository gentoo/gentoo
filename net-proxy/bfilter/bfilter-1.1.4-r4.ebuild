# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools flag-o-matic user

DESCRIPTION="Ad-filtering web proxy featuring an effective heuristic ad-detection algorithm"
HOMEPAGE="http://bfilter.sourceforge.net/"
SRC_URI="mirror://sourceforge/bfilter/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="X debug"

RDEPEND="sys-libs/zlib
	dev-libs/ace:=
	dev-libs/libsigc++:2
	X? ( dev-cpp/gtkmm:2.4 x11-libs/libX11 )
	dev-libs/boost:="

DEPEND="${RDEPEND}
	dev-util/scons
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${P}-glib-2.32.patch"
	"${FILESDIR}/${P}-external-boost.patch"
	"${FILESDIR}/${P}-gtkmm-X11-underlinking.patch"
)

RESTRICT="test" # boost's test API has changed

src_prepare() {
	default

	# Some includes are missing and this breaks updates of ACE
	sed -i \
		-e "/#include <ace\/Synch.h>/a#include <ace\/Condition_T.h>\n#include <ace\/Guard_T.cpp>" \
		libjs/nspr_impl/private.h \
		main/*.h \
		main/cache/*.h || die

	mv configure.{in,ac} || die
	rm -r boost || die

	eautoreconf
}

src_configure() {
	append-cxxflags -std=c++11
	# Required to prevent narrowing conversion in lexcode.cpp, #572072
	append-cxxflags -funsigned-char
	econf \
		$(use_enable debug) \
		$(use_with X gui) \
		--without-builtin-boost
}

src_install() {
	default

	insinto /etc/bfilter
	doins "${FILESDIR}/forwarding.xml"

	dodoc "${FILESDIR}/forwarding-proxy.xml"
	dodoc -r doc/*

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
