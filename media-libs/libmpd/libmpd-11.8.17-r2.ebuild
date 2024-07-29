# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A library handling connections to a MPD server"
HOMEPAGE="https://gmpclient.org/"
SRC_URI="http://download.sarine.nl/Programs/gmpc/$(ver_cut 1-2)/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~ia64 ~loong ppc ppc64 ~riscv x86 ~amd64-linux ~x86-linux"
IUSE="doc static-libs"

BDEPEND="
	virtual/pkgconfig
	doc? ( app-text/doxygen )
"
DEPEND=">=dev-libs/glib-2.16:2"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-remove-strndup.patch
	"${FILESDIR}"/${P}-return-0-instead-of-null.patch
)

src_configure() {
	econf $(use_enable static-libs static)
}

src_compile() {
	emake
	use doc && emake -C doc doc
}

src_install() {
	use doc && local HTML_DOCS=( doc/html/* )
	default
	find "${D}" -name '*.la' -type f -delete || die
	rm "${ED}"/usr/share/doc/${PF}/{README,ChangeLog} || die
}
