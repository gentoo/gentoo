# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

MY_P="super-smack-${PV}"

DESCRIPTION="Benchmarking, stress testing, and load generation tool for MySQL & PostGreSQL"
HOMEPAGE="http://vegan.net/tony/supersmack/"
SRC_URI="mirror://gentoo/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="+mysql postgres"
REQUIRED_USE="|| ( mysql postgres )"

DEPEND="
	sys-libs/zlib:=
	mysql? ( dev-db/mysql-connector-c:= )
	postgres? ( dev-db/postgresql:*[server] )"
RDEPEND="
	${DEPEND}
	mysql? ( virtual/mysql )"
BDEPEND="
	sys-devel/bison
	sys-devel/flex"

PATCHES=(
	"${FILESDIR}"/${PN}-1.2.destdir.patch
	"${FILESDIR}"/${PN}-1.3.amd64.patch
	"${FILESDIR}"/${PN}-1.3.gcc4.3.patch
	"${FILESDIR}"/${PN}-1.3-gen-data.patch
	"${FILESDIR}"/${PN}-1.3-autotools.patch
)

src_prepare() {
	default
	# Clean up files so eautoreconf does not pick up any
	# deprecated autotools macros.
	rm acinclude.m4 aclocal.m4 acconfig.h config.status config.h || die

	eautoreconf
}

src_configure() {
	append-cxxflags -std=gnu++98

	local myeconfargs=(
		$(usev mysql --with-mysql)
		$(usev postgres --with-pgsql)
		--with-datadir="${EPREFIX}"/var/tmp/super-smack
		--with-smacks-dir="${EPREFIX}"/usr/share/super-smack
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	dodoc MANUAL TUTORIAL

	keepdir /var/tmp/super-smack
}

pkg_postinst() {
	elog "The gen-data binary is now installed as super-smack-gen-data"
}
