# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="C/C++ toolkit for Z39.50v3 clients and servers"
HOMEPAGE="http://www.indexdata.dk/yaz"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/indexdata/yaz.git"
else
	SRC_URI="http://ftp.indexdata.dk/pub/${PN}/${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"
fi

LICENSE="BSD GPL-2"
SLOT="0/5"
IUSE="gnutls tcpd ziffy"

RDEPEND="
	dev-libs/icu:=
	dev-libs/libxml2
	dev-libs/libxslt
	sys-libs/readline:=
	sys-libs/ncurses:=
	virtual/libintl
	!gnutls? ( dev-libs/openssl:0= )
	gnutls? ( net-libs/gnutls:= )
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

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--enable-shared \
		$(use_with gnutls) \
		$(use_enable tcpd tcpd /usr)
}

src_install() {
	local docdir="/usr/share/doc/${PF}"
	emake DESTDIR="${D}" docdir="${EPREFIX}/${docdir}" install

	find "${D}" -name '*.la' -delete || die

	dodir "${docdir}"/html
	mv -f "${ED}"/${docdir}/*.{html,png} "${ED}"/${docdir}/html/ || die "Failed to move HTML docs"
	mv -f "${ED}"/usr/share/doc/${PN}/common "${ED}"/${docdir}/html/ || die "Failed to move HTML docs"
	rm -rf "${ED}"/usr/share/doc/${PN} || die

	dodoc ChangeLog NEWS
}
