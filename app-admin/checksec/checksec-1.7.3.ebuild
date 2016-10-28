# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils

MY_PN=${PN}.sh
DESCRIPTION="Tool to check properties of executables (e.g. ASLR/PIE, RELRO, PaX, Canaries)"
HOMEPAGE="https://github.com/slimm609/checksec.sh"
SRC_URI="https://github.com/slimm609/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~mips ~ppc ~ppc64 ~x86"
IUSE=""

S="${WORKDIR}"/${MY_PN}-${PV}

DOCS=( ChangeLog README.md )

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.7.2-path.patch
}

src_install() {
	default
	dobin ${PN}
}
