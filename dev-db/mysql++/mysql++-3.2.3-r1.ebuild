# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools libtool flag-o-matic

DESCRIPTION="C++ API interface to the MySQL database"
HOMEPAGE="http://tangentsoft.net/mysql++/"
SRC_URI="http://www.tangentsoft.net/mysqlpp/releases/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0/3"
KEYWORDS="alpha amd64 hppa ~mips ppc sparc x86 ~amd64-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="doc"

RDEPEND="dev-db/mysql-connector-c:="
DEPEND="${RDEPEND}"
DOCS=( CREDITS.txt HACKERS.txt Wishlist doc/ssqls-pretty )
PATCHES=(
	"${FILESDIR}"/${PN}-3.2.1-gold.patch
	"${FILESDIR}"/${PN}-3.2.3-mariadb-10.2.patch
	"${FILESDIR}"/${PN}-3.2.3-as-needed.patch
)

src_prepare() {
	# Bug filed upstream about deprecated std::auto_ptr
	append-cxxflags $(test-flags-CXX -Wno-deprecated-declarations)
	# Bad symlink for libtool in the archive
	rm "${S}/ltmain.sh" || die

	default

	_elibtoolize --auto-ltdl --install --copy --force
	elibtoolize
	# Current MySQL libraries are always with threads and slowly being removed
	sed -i -e "s/mysqlclient_r/mysqlclient/" "${S}/configure" || die
	rm "${S}/doc/"README-*-RPM.txt || die
}

src_configure() {
	local myconf=(
		--enable-thread-check
		--with-mysql="${EPREFIX}/usr"
		--with-mysql-lib="${EPREFIX}$(mysql_config --variable=pkglibdir)"
		--with-mysql-include="${EPREFIX}$(mysql_config --variable=pkgincludedir)"
	)
	econf "${myconf[@]}"
}

src_install() {
	default
	# install the docs and HTML pages
	use doc && dodoc -r doc/pdf/ doc/refman/ doc/userman/ doc/html/
}
