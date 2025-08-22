# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="C++ SVG library"
HOMEPAGE="https://github.com/svgpp/svgpp"
SRC_URI="https://github.com/svgpp/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Boost-1.0"
SLOT="0"
KEYWORDS="~amd64"

src_install() {
	doheader -r include/*
}
