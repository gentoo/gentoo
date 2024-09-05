# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit edos2unix

MY_PN="irrlicht"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="Irrlicht 3D engine headers"
HOMEPAGE="https://irrlicht.sourceforge.io/"
SRC_URI="https://downloads.sourceforge.net/irrlicht/${MY_P}.zip
	https://dev.gentoo.org/~mgorny/dist/${MY_PN}-1.8.4-patchset.tar.bz2"
S="${WORKDIR}/${MY_P}/source/${MY_PN^}"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"

BDEPEND="app-arch/unzip"

PATCHES=(
	"${WORKDIR}"/${MY_PN}-1.8.4-patchset/${MY_PN}-1.8.4-config.patch
)

src_prepare() {
	cd "${WORKDIR}"/${MY_P} || die
	edos2unix include/IrrCompileConfig.h
	default
}

src_configure() { :; }

src_compile() { :; }

src_install() {
	cd "${WORKDIR}"/${MY_P} || die

	insinto /usr/include/${MY_PN}
	doins include/*
}
