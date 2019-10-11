# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit font

DESCRIPTION="Microsoft's TrueType core fonts"
HOMEPAGE="http://corefonts.sourceforge.net/"
SRC_URI="mirror://gentoo/EUupdate.EXE
	mirror://sourceforge/corefonts/andale32.exe
	mirror://sourceforge/corefonts/arialb32.exe
	mirror://sourceforge/corefonts/comic32.exe
	mirror://sourceforge/corefonts/courie32.exe
	mirror://sourceforge/corefonts/georgi32.exe
	mirror://sourceforge/corefonts/impact32.exe
	mirror://sourceforge/corefonts/webdin32.exe
	mirror://sourceforge/corefonts/wd97vwr32.exe"

LICENSE="MSttfEULA"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris ~x86-winnt"
IUSE="X tahoma"

DEPEND="app-arch/cabextract"

S=${WORKDIR}
FONT_S=${WORKDIR}
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
