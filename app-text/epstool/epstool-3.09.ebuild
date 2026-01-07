# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Creates or extracts preview images in EPS files, fixes bounding boxes"
HOMEPAGE="http://www.ghostgum.com.au/software/epstool.htm"
SRC_URI="http://www.ghostgum.com.au/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ppc ppc64 ~riscv x86"

DEPEND="app-text/ghostscript-gpl"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-no-use-gnu.patch
	"${FILESDIR}"/${P}-no-gcc-linker.patch
)

src_prepare() {
	default
	tc-export CC

	# parallel make issue (bug #506978)
	mkdir bin || die
	mkdir epsobj || die
}

src_compile() {
	emake CC="$(tc-getCC)" epstool
}

src_install() {
	dobin bin/epstool
	doman doc/epstool.1
	local HTML_DOCS=( doc/epstool.htm doc/gsview.css )
	einstalldocs
}
