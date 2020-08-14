# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools

MY_PN="Sablot"
MY_P="${MY_PN}-${PV}"
S=${WORKDIR}/${MY_P}

DESCRIPTION="An XSLT Parser in C++"
HOMEPAGE="https://sourceforge.net/projects/sablotron/"
SRC_URI="mirror://sourceforge/sablotron/${MY_P}.tar.gz"

# Sablotron can optionally be built under GPL, using MPL for now
LICENSE="MPL-1.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="perl static-libs"

RDEPEND="
	>=dev-libs/expat-1.95.6-r1
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	>=dev-perl/XML-Parser-2.3
"
DOCS=(
	README README_JS RELEASE src/TODO
)
PATCHES=(
	"${FILESDIR}"/1.0.3-libsablot-expat.patch
	"${FILESDIR}"/1.0.3-cxx11.patch
)

src_prepare() {
	default
	sed -i configure.in -e 's|AM_CONFIG_HEADER|AC_CONFIG_HEADERS|g' || die
	eautoreconf
	elibtoolize
}

src_configure() {
	econf \
		$(use_enable perl perlconnect) \
		$(use_enable static-libs static) \
		--with-html-dir="${EPREFIX}"/usr/share/doc/${PF}/html
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
