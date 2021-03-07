# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools toolchain-funcs

DESCRIPTION="RadiusClient NextGeneration - library for RADIUS clients"
HOMEPAGE="https://sourceforge.net/projects/radiusclient-ng.berlios/"
SRC_URI="mirror://sourceforge/${PN}.berlios/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc x86"

DEPEND="!net-dialup/radiusclient
	!net-dialup/freeradius-client"
RDEPEND="${DEPEND}"

DOCS=( BUGS CHANGES README )
HTML_DOCS=( doc/instop.html )

PATCHES=(
	"${FILESDIR}/${P}-cross-compile.patch"
)

src_prepare() {
	default

	mv configure.{in,ac} || die

	eautoreconf
}

src_configure() {
	# bug #373365
	if tc-is-cross-compiler ; then
		export ac_cv_file__dev_urandom=yes
		export ac_cv_struct_utsname=no
	fi

	econf
}

src_install() {
	default

	find "${ED}" -name '*.a' -delete || die
}
