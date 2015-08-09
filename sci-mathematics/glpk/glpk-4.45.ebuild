# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

inherit eutils flag-o-matic

DESCRIPTION="GNU Linear Programming Kit"
LICENSE="GPL-3"
HOMEPAGE="http://www.gnu.org/software/glpk/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

SLOT="0"
IUSE="doc examples gmp odbc mysql static-libs"
KEYWORDS="alpha amd64 hppa ppc ppc64 sparc x86 ~ppc-aix ~x86-fbsd ~amd64-linux ~x86-linux"

RDEPEND="sys-libs/zlib
	odbc? ( || ( dev-db/libiodbc dev-db/unixODBC ) )
	gmp? ( dev-libs/gmp )
	mysql? ( virtual/mysql )"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	epatch 	"${FILESDIR}"/${PN}-4.52.1-mariadb-5.5.patch
}

src_configure() {
	local myconf="--disable-dl"
	if use mysql || use odbc; then
		myconf="--enable-dl"
	fi

	[[ -z $(type -P odbc-config) ]] && \
		append-cppflags $(pkg-config --cflags libiodbc)

	econf \
		--with-zlib \
		$(use_enable static-libs static) \
		$(use_with gmp) \
		$(use_enable odbc) \
		$(use_enable mysql) \
		${myconf}
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	dodoc AUTHORS ChangeLog NEWS README || \
		die "failed to install docs"

	insinto /usr/share/doc/${PF}
	if use examples; then
		emake distclean
		doins -r examples || die "failed to install examples"
	fi
	if use doc; then
		cd "${S}"/doc
		doins *.pdf notes/*.pdf || die "failed to instal djvu and pdf"
		dodoc *.txt || die "failed to install manual files"
	fi
}
