# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Paging program that displays, one windowful at a time, the contents of a file"
HOMEPAGE="https://www.jedsoft.org/most/"
SRC_URI="https://www.jedsoft.org/releases/${PN}/${P}.tar.gz
	https://www.jedsoft.org/releases/${PN}/old/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~mips ppc ~ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"

RDEPEND=">=sys-libs/slang-2.1.3"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-5.0.0a-donot-hardcode-path.patch
)

src_prepare() {
	default
	# Do not strip by default
	sed -e '/\$(INSTALL)/s@ -s@@' -i src/Makefile.in || die
}

src_configure() {
	unset ARCH
	econf
}

src_install() {
	emake DESTDIR="${D}" DOC_DIR="${EPREFIX}/usr/share/doc/${PF}" \
		install
}
