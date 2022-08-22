# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN%-mt-headers}"
MY_PV="$(ver_rs 3 'mt')"
MY_P="${MY_PN}-${MY_PV}"
# These two should be kept in sync with dev-games/irrlicht-mt
SRC_PN="${PN%-headers}"
SRC_P="${SRC_PN}-${PV}"

DESCRIPTION="Header files for Minetest's fork of dev-games/irrlicht"
HOMEPAGE="https://github.com/minetest/irrlicht"
SRC_URI="https://github.com/minetest/${MY_PN}/archive/refs/tags/${MY_PV}.tar.gz -> ${SRC_P}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~riscv"

RDEPEND="!<dev-games/irrlicht-mt-1.9.0.4-r1"

S="${WORKDIR}"/${MY_P}

src_configure() { :; }

src_compile() { :; }

src_install() {
	insinto /usr/include/${SRC_PN/-/}
	doins include/*
}
