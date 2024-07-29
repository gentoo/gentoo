# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Bob Hyatt's strong chess engine"
HOMEPAGE="https://web.archive.org/web/20231106192545/http://craftychess.com/"
SRC_URI="https://web.archive.org/web/20210304102649/http://www.craftychess.com/downloads/source/${P}.zip
	mirror://gentoo/85/${PN}.doc.ascii"

LICENSE="crafty"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~loong ~riscv ~x86"
IUSE="no-opts"
RESTRICT="test"

BDEPEND="app-arch/unzip"

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
	tc-export CC CXX
	append-cppflags -DPOSIX -DSKILL
	emake ${makeopts} crafty-make LDFLAGS="${LDFLAGS} -pthread"
}

src_install() {
	dobin crafty
	insinto "/usr/share/${PN}"
	doins crafty.hlp
	dodoc "${DISTDIR}"/crafty.doc.ascii
}
