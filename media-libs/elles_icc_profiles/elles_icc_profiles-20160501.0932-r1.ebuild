# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PV="$(ver_rs 1 '-')EST"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="Elle Stone's well-behaved RGB and grey ICC profiles"
HOMEPAGE="https://ninedegreesbelow.com/photography/lcms-make-icc-profiles.html"
SRC_URI="https://github.com/ellelstone/${PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="amd64 ~riscv"

S="${WORKDIR}/${MY_P}"

src_install() {
	default

	insinto /usr/share/color/icc/ellestone
	doins profiles/*.icc
}
