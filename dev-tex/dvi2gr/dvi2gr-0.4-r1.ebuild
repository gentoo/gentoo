# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs virtualx

DESCRIPTION="DVI to Grace translator"
HOMEPAGE="https://plasma-gate.weizmann.ac.il/Grace/"
SRC_URI="ftp://plasma-gate.weizmann.ac.il/pub/grace/src/devel/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"

IUSE="examples test"
#RESTRICT="!test? ( test )"
# Still missing some fontpackage, but which?
RESTRICT="test"

DEPEND="media-libs/t1lib"
RDEPEND="${DEPEND}"
BDEPEND="test? (
	sci-visualization/grace
)"

src_prepare() {
	tc-export CC
	default
	# respect flags
	sed -i \
		-e '/^LDFLAGS/d' -e '/^CFLAGS/d' -e '/^CC/d' \
		Makefile || die
	sed -i -e 's/DVI2GR=\.\/dvi2gr/DVI2GR=$(which dvi2gr)/g' runtest.sh || die
}

src_install() {
	dobin ${PN}
	if use examples; then
		docinto /usr/share/doc/${PF}/examples
		dodoc *.ti runtest.sh
	fi

	insinto /usr/share/${PN}
	doins -r fonts
}

src_test() {
	virtx default
}

pkg_postinst() {
	einfo "Don't forget install the TeX-Fonts in Grace"
	einfo "  /usr/share/${PN}/fonts/FontDataBase"
}
