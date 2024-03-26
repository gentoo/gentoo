# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="TCL MySQL Interface"
HOMEPAGE="http://www.xdobry.de/mysqltcl/"
SRC_URI="http://www.xdobry.de/mysqltcl/${P}.tar.gz"

LICENSE="HPND"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc x86"

DEPEND="
	dev-lang/tcl:0=
	dev-db/mysql-connector-c:0="
RDEPEND="${DEPEND}"

QA_CONFIG_IMPL_DECL_SKIP=(
	stat64 # used to test for Large File Support
)

PATCHES=(
	"${FILESDIR}"/${PN}-3.05-ldflags.patch
	"${FILESDIR}"/${PN}-3.05-API.patch
)
HTML_DOCS=( doc/mysqltcl.html )

src_prepare() {
	default_src_prepare
	sed -i 's/-pipe//g;s/-O2//g;s/-fomit-frame-pointer//g' configure || die
}

src_configure() {
	econf --with-mysql-lib=$(mysql_config --variable=pkglibdir)
}
