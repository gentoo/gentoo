# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

MY_P="Sablot-${PV}"

DESCRIPTION="An XSLT Parser in C++"
HOMEPAGE="https://sourceforge.net/projects/sablotron/"
SRC_URI="https://downloads.sourceforge.net/sablotron/${MY_P}.tar.gz"
S=${WORKDIR}/${MY_P}

# Sablotron can optionally be built under GPL, using MPL for now
LICENSE="MPL-1.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~mips ppc ppc64 ~s390 ~sparc x86"
IUSE="perl"

DEPEND=">=dev-libs/expat-1.95.6-r1"
RDEPEND="${DEPEND}"
BDEPEND=">=dev-perl/XML-Parser-2.3"

DOCS=( README README_JS RELEASE src/TODO )

PATCHES=(
	"${FILESDIR}"/${PN}-1.0.3-libsablot-expat.patch
	"${FILESDIR}"/${PN}-1.0.3-cxx11.patch
	"${FILESDIR}"/${PN}-1.0.3-drop-register-keyword.patch
)

src_prepare() {
	default
	sed -i configure.in -e 's|AM_CONFIG_HEADER|AC_CONFIG_HEADERS|g' || die
	mv configure.{in,ac} || die
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable perl perlconnect)
		--with-html-dir="${EPREFIX}"/usr/share/doc/${PF}/html
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
