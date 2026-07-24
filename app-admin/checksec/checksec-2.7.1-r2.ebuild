# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit shell-completion

DESCRIPTION="Tool to check properties of executables (e.g. ASLR/PIE, RELRO, PaX, Canaries)"
HOMEPAGE="https://github.com/slimm609/checksec"
SRC_URI="https://github.com/slimm609/checksec/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"

RDEPEND="
	sys-apps/grep[pcre]
	!<dev-util/pwntools-4.10.0_beta0-r2
"

DOCS=( ChangeLog README.md )

src_prepare() {
	sed 's,^pkg_release=false,pkg_release=true,' -i ${PN} || die
	rm Makefile || die
	default
}

src_install() {
	default

	doman extras/man/*

	dozshcomp extras/zsh/_${PN}

	dobin ${PN}
}
