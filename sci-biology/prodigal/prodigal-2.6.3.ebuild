# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Prokaryotic Dynamic Programming Genefinding Algorithm"
HOMEPAGE="http://prodigal.ornl.gov/"
SRC_URI="https://github.com/hyattpd/${PN^}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND=""

S=${WORKDIR}/${P^}

PATCHES=( "${FILESDIR}"/${PN}-2.6.3-fix-build-system.patch )

src_configure() {
	tc-export CC
}
