# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

MY_P="XQilla-${PV}"

DESCRIPTION="An XQuery and XPath 2 library and command line utility written in C++"
HOMEPAGE="http://xqilla.sourceforge.net/HomePage"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"
LICENSE="Apache-2.0 BSD"
SLOT="0/2"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc examples faxpp static-libs tidy"

# XQilla bundles two libraries:
# - mapm, heavily patched
# - yajl, moderately patched
# There's currently no way to unbundle those

RDEPEND=">=dev-libs/xerces-c-3.2.2
	faxpp? ( dev-libs/faxpp )
	tidy? ( app-text/tidy-html5 )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

PATCHES=(
	"${FILESDIR}/2.2.4-respect-ldflags-no-rpath.patch"
	"${FILESDIR}/${P}-tidy.patch"
)

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default
	mv configure.{in,ac} || die
	eautoreconf
}

src_configure() {
	econf \
		--with-xerces="${EPREFIX}"/usr \
		$(use_enable debug) \
		$(use_with tidy tidy /usr) \
		$(use_with faxpp faxpp /usr) \
		$(use_enable static-libs static)
}

src_compile() {
	default
	use doc && emake docs devdocs
}

src_install () {
	use doc && local HTML_DOCS=( docs/{dev-api,dom3-api,simple-api} )
	default

	find "${D}" -name '*.la' -delete || die

	if use examples; then
		docinto examples
		dodoc -r "${S}"/src/samples/.
	fi

	# remove unnecessary files previously filtered by dohtml
	find "${ED%/}/usr/share/doc/${PF}" \
		\( -name '*.map' -o -name '*.md5' \) -delete || die
}
