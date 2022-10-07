# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Converts DVI files to SVG"
HOMEPAGE="https://dvisvgm.de/"
SRC_URI="https://github.com/mgieseki/dvisvgm/releases/download/${PV}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~ppc-macos ~x64-macos"
IUSE="test"

# Tests don't work from ${WORKDIR}: kpathsea tries to search in relative
# directories from where the binary is executed.
# We cannot really use absolute paths in the kpathsea configuration since that
# would make it harder for prefix installs.
RESTRICT="test"

RDEPEND="
	>=app-arch/brotli-1.0.5:=
	app-text/ghostscript-gpl:=
	dev-libs/kpathsea:=
	dev-libs/openssl:=
	>=dev-libs/xxhash-0.8.1
	>=media-gfx/potrace-1.10-r1
	media-libs/freetype:2
	>=media-libs/woff2-1.0.2
	sys-libs/zlib
	virtual/tex-base
"
DEPEND="
	${RDEPEND}
	test? ( >=dev-cpp/gtest-1.11 )
"
BDEPEND="
	app-text/asciidoc
	app-text/xmlto
	dev-libs/libxslt
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${P}-ghostscript.patch
	"${FILESDIR}"/${PN}-2.14-Add-missing-cstdint-includes-for-GCC-13.patch
)

src_configure() {
	local myargs=(
		--without-ttfautohint
	)

	econf "${myargs[@]}"
}
