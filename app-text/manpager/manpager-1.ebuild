# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit toolchain-funcs

DESCRIPTION="Enable colorization of man pages"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 ~riscv s390 sparc x86 ~amd64-linux ~x86-linux"
IUSE=""

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
	insinto /etc/env.d
	echo "MANPAGER=manpager" | newins - 00manpager
}
