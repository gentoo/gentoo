# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P="${PN}-${PV/_p/c}"

DESCRIPTION="Volume rendering library"
HOMEPAGE="https://amide.sourceforge.net/packages.html"
SRC_URI="mirror://sourceforge/amide/${MY_P}.tgz"
S="${WORKDIR}/${MY_P}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples"

BDEPEND="sys-devel/m4"

PATCHES=(
	"${FILESDIR}"/${P}-skip-examples.patch
)

src_compile() {
	emake -j1
}

src_install() {
	default

	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi

	if use doc; then
		dodoc doc/*.pdf

		docinto html
		dodoc doc/*.html
	fi

	find "${ED}" -type f -name '*.la' -delete || die
}
