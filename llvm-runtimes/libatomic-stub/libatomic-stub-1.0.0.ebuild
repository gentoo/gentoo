# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Stub library which allows compiler-rt to be used as an libatomic"
S="${WORKDIR}"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	llvm-runtimes/compiler-rt[atomic-builtins]
	!sys-devel/gcc
"

src_install() {
	mkdir -p "${D}/usr/lib" || die
	${AR} rc "${D}/usr/lib/libatomic.a" || die
}
