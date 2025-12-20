# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="Microsoft's TrueType core fonts"
HOMEPAGE="https://corefonts.sourceforge.net/"
SRC_URI="mirror://gentoo/EUupdate.EXE
	https://downloads.sourceforge.net/corefonts/andale32.exe
	https://downloads.sourceforge.net/corefonts/arialb32.exe
	https://downloads.sourceforge.net/corefonts/comic32.exe
	https://downloads.sourceforge.net/corefonts/courie32.exe
	https://downloads.sourceforge.net/corefonts/georgi32.exe
	https://downloads.sourceforge.net/corefonts/impact32.exe
	https://downloads.sourceforge.net/corefonts/webdin32.exe
	https://downloads.sourceforge.net/corefonts/wd97vwr32.exe"
S="${WORKDIR}"

LICENSE="MSttfEULA"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"
IUSE="X tahoma"

BDEPEND="app-arch/cabextract"

FONT_SUFFIX="ttf"

src_unpack() {
	for exe in ${A} ; do
		echo ">>> Unpacking ${exe} to ${WORKDIR}"
		cabextract --lowercase "${DISTDIR}"/${exe} > /dev/null \
			|| die "failed to unpack ${exe}"
	done
	if use tahoma; then
		cabextract -F 'tahoma.ttf' "${WORKDIR}/viewer1.cab" > /dev/null \
			|| die "failed to unpack tahoma.ttf"
	fi
}

src_install() {
	font_src_install
	# The license explicitly states that the license must be distributed with the
	# fonts. The only way to do that for the binpkg is to include it.
	dodoc license.txt
}
