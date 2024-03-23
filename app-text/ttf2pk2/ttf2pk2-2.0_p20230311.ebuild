# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Freetype 2 based TrueType font to TeX's PK format converter"
HOMEPAGE="https://tug.org/texlive/"
SRC_URI="https://mirrors.ctan.org/systems/texlive/Source/texlive-${PV#*_p}-source.tar.xz"
S="${WORKDIR}/texlive-${PV#*_p}-source/texk/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

# Note about blockers: it is a freetype2 based replacement for ttf2pk and
# ttf2tfm from freetype1, so block freetype1.
# It installs some data that collides with
# dev-texlive/texlive-langcjk-2011[source]. Hope it'd be fixed with 2012,
# meanwhile we can start dropping freetype1.
RDEPEND="
	>=dev-libs/kpathsea-6.2.1
	media-libs/freetype:2
	sys-libs/zlib
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_configure() {
	econf \
		--with-system-kpathsea \
		--with-system-freetype2 \
		--with-system-zlib
}
