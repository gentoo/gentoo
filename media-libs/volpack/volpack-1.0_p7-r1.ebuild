# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MYP=${PN}-${PV/_p/c}

DESCRIPTION="Volume rendering library"
HOMEPAGE="http://amide.sourceforge.net/packages.html"
SRC_URI="mirror://sourceforge/amide/${MYP}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples static-libs"

DEPEND="sys-devel/m4"

S="${WORKDIR}/${MYP}"

src_configure() {
	econf $(use_enable static-libs static)
}

src_compile() {
	emake -j1
}

src_install() {
	default
	if use doc; then
		dodoc doc/*.pdf
		docinto html
		dodoc doc/*.html
	fi

	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
