# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
WANT_AUTOMAKE="1.13"

inherit autotools libtool

MY_PN="super-smack"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="Benchmarking, stress testing, and load generation tool for MySQL & PostGreSQL"
HOMEPAGE="http://vegan.net/tony/supersmack/"
SRC_URI="mirror://gentoo/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="+mysql postgres"
REQUIRED_USE="|| ( mysql postgres )"

COMMON_DEPEND="sys-libs/zlib:=
		mysql? ( dev-db/mysql-connector-c:= )
		postgres? ( dev-db/postgresql:*[server] )"
DEPEND="${COMMON_DEPEND} sys-devel/bison sys-devel/flex"
RDEPEND="${COMMON_DEPEND} mysql? ( virtual/mysql )"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.2.destdir.patch
	"${FILESDIR}"/${PN}-1.3.amd64.patch
	"${FILESDIR}"/${PN}-1.3.gcc4.3.patch
	"${FILESDIR}"/${PN}-1.3-gen-data.patch
	"${FILESDIR}"/${PN}-1.3-automake-1.13.patch
)
DOCS=( CHANGES INSTALL MANUAL README TUTORIAL )

src_prepare() {
	# Clean up files so eautoreconf does not pick up any
	# deprecated autotools macros.
	rm acinclude.m4 aclocal.m4 acconfig.h config.status config.h || die
	mv configure.in configure.ac || die
	export CXXFLAGS+=" -std=gnu++98"
	default
	eautoreconf
	elibtoolize --patch-only
}

src_configure() {
	local myeconfargs=(
		$(usex mysql --with-mysql "")
		$(usex postgres --with-pgsql "")
		--with-datadir=/var/tmp/${MY_PN}
		--with-smacks-dir=/usr/share/${MY_PN}
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	keepdir /var/tmp/${MY_PN}
}

pkg_postinst() {
	elog "The gen-data binary is now installed as super-smack-gen-data"
}
