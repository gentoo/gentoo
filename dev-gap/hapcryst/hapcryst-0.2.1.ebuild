# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gap-pkg

DESCRIPTION="A HAP extension for crytallographic groups"
SRC_URI="https://github.com/gap-packages/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~riscv"
IUSE="examples"

RDEPEND="dev-gap/aclib
	dev-gap/cryst
	dev-gap/hap
	dev-gap/polycyclic
	dev-gap/polymaking"

gap-pkg_enable_tests

src_compile() {
	# the docs aren't pre-built in >= 0.2.0
	gap -R -A --nointeract --packagedirs . makedoc.g || die
}

src_install() {
	gap-pkg_src_install
	use examples && dodoc -r examples
}
