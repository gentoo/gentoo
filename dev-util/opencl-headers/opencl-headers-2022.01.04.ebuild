# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="OpenCL-Headers"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Unified C language headers for the OpenCL API"
HOMEPAGE="https://github.com/KhronosGroup/OpenCL-Headers"
SRC_URI="https://github.com/KhronosGroup/${MY_PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ppc64 x86"

S="${WORKDIR}"/${MY_P}

src_install() {
	insinto /usr/include
	doins -r "${S}"/CL

	einstalldocs
}
