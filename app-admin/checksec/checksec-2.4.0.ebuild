# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

MY_PN=${PN}.sh
DESCRIPTION="Tool to check properties of executables (e.g. ASLR/PIE, RELRO, PaX, Canaries)"
HOMEPAGE="https://github.com/slimm609/checksec.sh"
SRC_URI="https://github.com/slimm609/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~mips ~ppc ~ppc64 ~sparc x86"
IUSE=""

S="${WORKDIR}"/${MY_PN}-${PV}

DOCS=( ChangeLog README.md )

PATCHES=(
	"${FILESDIR}"/${PN}-1.7.2-path.patch
)

src_prepare() {
	sed 's,^pkg_release=false,pkg_release=true,' -i ${PN} || die
	default
}

src_install() {
	default

	doman extras/man/*

	insinto /usr/share/zsh/site-functions
	doins extras/zsh/_${PN}

	dobin ${PN}
}
