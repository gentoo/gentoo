# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

MY_PN=${PN}.sh
DESCRIPTION="Tool to check properties of executables (e.g. ASLR/PIE, RELRO, PaX, Canaries)"
HOMEPAGE="https://github.com/slimm609/checksec.sh"
SRC_URI="https://github.com/slimm609/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}"/${MY_PN}-${PV}

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~loong ~mips ~ppc ppc64 ~riscv ~sparc x86"

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

	insinto /usr/share/zsh/site-functions
	doins extras/zsh/_${PN}

	dobin ${PN}
}
