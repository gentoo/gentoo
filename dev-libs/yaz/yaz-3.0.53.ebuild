# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="C/C++ toolkit for Z39.50v3 clients and servers"
HOMEPAGE="http://www.indexdata.dk/yaz"
SRC_URI="http://ftp.indexdata.dk/pub/${PN}/${P}.tar.gz"

LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~mips ~ppc ppc64 ~s390 ~sparc x86"
IUSE="debug icu gnutls tcpd ziffy"

RDEPEND="
	dev-libs/libxml2
	dev-libs/libxslt
	sys-libs/readline:=
	sys-libs/ncurses:=
	virtual/libintl
	!gnutls? ( dev-libs/openssl:0= )
	gnutls? ( net-libs/gnutls:= )
	icu? ( dev-libs/icu:= )
	tcpd? ( sys-apps/tcp-wrappers )
	ziffy? ( net-libs/libpcap )
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-lang/tcl:0
	sys-devel/bison
	>=sys-devel/libtool-2
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${PN}-3.0.47-icu-automagic.patch
)

src_prepare() {
	default
	AT_M4DIR="m4" eautoreconf
}

src_configure() {
	econf \
		--enable-static \
		--enable-shared \
		$(use_enable debug memdebug) \
		$(use_with gnutls) \
		$(use_enable icu) \
		$(use_enable tcpd tcpd /usr)
}

src_install() {
	local docdir="/usr/share/doc/${PF}"
	emake DESTDIR="${D}" docdir="${EPREFIX}/${docdir}" install

	dodir "${docdir}"/html
	mv -f "${ED}"/${docdir}/*.{html,png} "${ED}"/${docdir}/html/ || die "Failed to move HTML docs"
	mv -f "${ED}"/usr/share/doc/${PN}/common "${ED}"/${docdir}/html/ || die "Failed to move HTML docs"
	rm -rf "${ED}"/usr/share/doc/${PN} || die

	dodoc ChangeLog NEWS README
}
