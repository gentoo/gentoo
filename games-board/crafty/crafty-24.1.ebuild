# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit flag-o-matic toolchain-funcs eutils games

DESCRIPTION="Bob Hyatt's strong chess engine"
HOMEPAGE="http://www.craftychess.com/"
SRC_URI="http://www.craftychess.com/${P}.zip
	http://www.cis.uab.edu/hyatt/crafty/source/${P}.zip
	ftp://ftp.cis.uab.edu/pub/hyatt/documentation/${PN}.doc.ascii"

LICENSE="crafty"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="no-opts"
RESTRICT="test"

RDEPEND=""
DEPEND="${RDEPEND}
	app-arch/unzip"

src_prepare() {
	sed -i \
		-e '/-o crafty/s/CC/CXX/' \
		-e 's:CXFLAGS:CXXFLAGS:g' \
		-e 's:-j ::g' \
		Makefile || die
	sed -i \
		-e "s:\"crafty.hlp\":\"${GAMES_DATADIR}/${PN}/crafty.hlp\":" option.c || die
	epatch "${FILESDIR}"/${P}-numcpus.patch
}

src_compile() {
	local makeopts="target=UNIX"

	if ! use no-opts ; then
		if [[ $(tc-getCC) = icc ]] ; then
			makeopts="${makeopts} asm=X86.o"
			append-flags -D_REENTRANT -tpp6 \
				-DCOMPACT_ATTACKS -DUSE_ATTACK_FUNCTIONS \
				-DUSE_ASSEMBLY_A -DUSE_ASSEMBLY_B -DFAST \
				-DSMP -DCPUS=4 -DCLONE -DDGT
			append-flags -O2 -fno-alias -fforce-mem \
				-fomit-frame-pointer -fno-gcse -mpreferred-stack-boundary=2
		else
			if [[ "${CHOST}" == "i686-pc-linux-gnu" ]] \
			|| [[ "${CHOST}" == "i586-pc-linux-gnu" ]] ; then
				append-flags -DCOMPACT_ATTACKS -DUSE_ATTACK_FUNCTIONS \
					-DUSE_ASSEMBLY_A -DUSE_ASSEMBLY_B \
					-DFAST -DSMP -DCPUS=4 -DCLONE -DDGT
				append-flags -fno-gcse \
					-fomit-frame-pointer -mpreferred-stack-boundary=2
			elif [[ "${CHOST}" == "x86_64-pc-linux-gnu" ]] ; then
				append-flags -DCOMPACT_ATTACKS -DUSE_ATTACK_FUNCTIONS \
					-DUSE_ASSEMBLY_A -DUSE_ASSEMBLY_B \
					-DFAST -DSMP -DCPUS=4 -DCLONE -DDGT
				append-flags -fomit-frame-pointer
			else
				: # everything else :)
			fi
		fi
	fi
	append-flags -DPOSIX -DSKILL
	emake ${makeopts} crafty-make LDFLAGS="${LDFLAGS} -pthread"
}

src_install() {
	dogamesbin crafty
	insinto "${GAMES_DATADIR}/${PN}"
	doins crafty.hlp
	dodoc "${DISTDIR}"/crafty.doc.ascii
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	elog
	elog "Note: No books or tablebases have been installed. If you want them, just"
	elog "      download them from ${HOMEPAGE}."
	elog "      You will find documentation there too. In most cases you take now "
	elog "      your xboard compatible application, (xboard, eboard, knights) and "
	elog "      just play chess against computer opponent. Have fun."
	elog
}
