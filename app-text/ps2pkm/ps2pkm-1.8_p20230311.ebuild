# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Tool that converts a PostScript type1 font into a corresponding TeX PK font"
HOMEPAGE="https://tug.org/texlive/"
SRC_URI="https://mirrors.ctan.org/systems/texlive/Source/texlive-${PV#*_p}-source.tar.xz"
S="${WORKDIR}/texlive-${PV#*_p}-source/texk/ps2pk"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

DEPEND=">=dev-libs/kpathsea-6.2.1:="
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

DOCS=( "ChangeLog" "CHANGES.type1" "README" "README.14m" "README.type1" )

src_configure() {
	econf \
		--with-system-kpathsea
}
