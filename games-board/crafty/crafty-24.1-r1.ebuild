# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit flag-o-matic toolchain-funcs

DESCRIPTION="Bob Hyatt's strong chess engine"
HOMEPAGE="http://www.craftychess.com/"
SRC_URI="http://www.craftychess.com/${P}.zip
	http://www.cis.uab.edu/hyatt/crafty/source/${P}.zip
	ftp://ftp.cis.uab.edu/pub/hyatt/documentation/${PN}.doc.ascii"

LICENSE="crafty"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="no-opts"
RESTRICT="test"

RDEPEND=""
DEPEND="${RDEPEND}
	app-arch/unzip"

src_prepare() {
	default
	sed -i \
		-e '/-o crafty/s/CC/CXX/' \
		-e 's:CXFLAGS:CXXFLAGS:g' \
		-e 's:-j ::g' \
		Makefile || die
	sed -i \
		-e "s:\"crafty.hlp\":\"/usr/share/${PN}/crafty.hlp\":" option.c || die
	eapply "${FILESDIR}"/${P}-numcpus.patch
}

src_compile() {
	local makeopts="target=UNIX"

	if ! use no-opts ; then
		if [[ $(tc-getCC) = icc ]] ; then
			makeopts="${makeopts} asm=X86.o"
			append-cppflags -D_REENTRANT -tpp6 \
				-DCOMPACT_ATTACKS -DUSE_ATTACK_FUNCTIONS \
				-DUSE_ASSEMBLY_A -DUSE_ASSEMBLY_B -DFAST \
				-DSMP -DCPUS=4 -DCLONE -DDGT
			append-flags -O2 -fno-alias -fforce-mem \
				-fomit-frame-pointer -fno-gcse -mpreferred-stack-boundary=2
		else
			if [[ "${CHOST}" == "i686-pc-linux-gnu" ]] \
			|| [[ "${CHOST}" == "i586-pc-linux-gnu" ]] ; then
				append-cppflags -DCOMPACT_ATTACKS -DUSE_ATTACK_FUNCTIONS \
					-DUSE_ASSEMBLY_A -DUSE_ASSEMBLY_B \
					-DFAST -DSMP -DCPUS=4 -DCLONE -DDGT
				append-flags -fno-gcse \
					-fomit-frame-pointer -mpreferred-stack-boundary=2
			elif [[ "${CHOST}" == "x86_64-pc-linux-gnu" ]] ; then
				append-cppflags -DCOMPACT_ATTACKS -DUSE_ATTACK_FUNCTIONS \
					-DUSE_ASSEMBLY_A -DUSE_ASSEMBLY_B \
					-DFAST -DSMP -DCPUS=4 -DCLONE -DDGT
				append-flags -fomit-frame-pointer
			else
				: # everything else :)
			fi
		fi
	fi
	append-cppflags -DPOSIX -DSKILL
	emake ${makeopts} crafty-make LDFLAGS="${LDFLAGS} -pthread"
}

src_install() {
	dobin crafty
	insinto "/usr/share/${PN}"
	doins crafty.hlp
	dodoc "${DISTDIR}"/crafty.doc.ascii
}
