# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="wxHexEditor"
WX_GTK_VER=3.2-gtk3
inherit flag-o-matic toolchain-funcs wxwidgets

DESCRIPTION="A cross-platform hex editor designed specially for large files"
HOMEPAGE="https://github.com/EUA/wxHexEditor"
SRC_URI="https://downloads.sourceforge.net/${PN}/${MY_PN}-v${PV}-src.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"

DEPEND="
	app-crypt/mhash
	dev-libs/udis86
	x11-libs/wxGTK:${WX_GTK_VER}[X]"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_PN}"

PATCHES=(
	"${FILESDIR}"/${P}-syslibs.patch
	"${FILESDIR}"/${P}-desktop.patch
	"${FILESDIR}"/${P}-wx3.2.patch
)

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && tc-check-openmp
}

src_prepare() {
	setup-wxwidgets
	default

	# -Werror=odr, -Werror=lto-type-mismatch
	# https://bugs.gentoo.org/854414
	# https://github.com/EUA/wxHexEditor/issues/222
	filter-lto
}
