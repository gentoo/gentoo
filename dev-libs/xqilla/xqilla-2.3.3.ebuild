# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools

MY_P="XQilla-${PV}"

DESCRIPTION="An XQuery and XPath 2 library and command line utility written in C++"
HOMEPAGE="http://xqilla.sourceforge.net/HomePage"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"
LICENSE="Apache-2.0 BSD"
SLOT="0/3"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc examples faxpp htmltidy static-libs"

# XQilla bundles two libraries:
# - mapm, heavily patched
# - yajl, moderately patched
# There's currently no way to unbundle those

RDEPEND=">=dev-libs/xerces-c-3.1.1
	faxpp? ( dev-libs/faxpp )
	htmltidy? ( app-text/htmltidy )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

PATCHES=(
	"${FILESDIR}/2.2.4-respect-ldflags-no-rpath.patch"
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
		$(use_with htmltidy tidy /usr) \
		$(use_with faxpp faxpp /usr) \
		$(use_enable static-libs static)
}

src_compile() {
	default
	use doc && emake docs devdocs
}

src_install () {
	use doc && HTML_DOCS=( docs/{dev-api,dom3-api,simple-api} )
	default

	if ! use static-libs; then
		find "${D}" -name '*.la' -delete || die
	fi

	if use examples; then
		docinto examples
		dodoc -r "${S}"/src/samples/.
	fi

	# remove unnecessary files previously filtered by dohtml
	find "${ED%/}/usr/share/doc/${PF}" \
		\( -name '*.map' -o -name '*.md5' \) -delete || die
}
