# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit versionator toolchain-funcs

MY_PV=$(replace_version_separator '')

DESCRIPTION="Konami VB2 sound format ripping utility"
HOMEPAGE="http://www.neillcorlett.com/vb2rip"
SRC_URI="http://www.neillcorlett.com/vb2rip/${PN}${MY_PV}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="app-arch/unzip"

S=${WORKDIR}/src

src_compile() {
	tc-export CC
	echo "vb2rip: main.o decode.o wav.o lsb.o rip.o fmt.o fmt_raw.o fmt_vb2.o fmt_8.o fmt_msa.o fmt_xa2.o" > Makefile
	echo '	$(CC) $(LDFLAGS) $^ -o $@' >> Makefile
	emake || die
}

src_install() {
	dobin vb2rip || die
	dodoc "${WORKDIR}/games.txt" "${WORKDIR}/vb2rip.txt"
}
