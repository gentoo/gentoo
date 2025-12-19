# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Enable colorization of man pages"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"

S=${WORKDIR}

src_compile() {
	local cmd=(
		$(tc-getCC) ${CFLAGS} ${CPPFLAGS} ${LDFLAGS}
		"${FILESDIR}"/manpager.c -o ${PN}
	)
	echo "${cmd[@]}"
	"${cmd[@]}" || die
}

src_install() {
	dobin ${PN}
	echo "MANPAGER=manpager" | newenvd - 00manpager
}
