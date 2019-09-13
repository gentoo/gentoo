# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit cmake-utils

DESCRIPTION="Perpetual date converter from gregorian to poee calendar"
HOMEPAGE="https://github.com/bo0ts/ddate"
SRC_URI="https://github.com/bo0ts/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="amd64 arm arm64 x86"
LICENSE="public-domain"
SLOT="0"

RDEPEND="!sys-apps/util-linux[ddate]"

DOCS=( "README.org" )

PATCHES=( "${FILESDIR}/${P}-dont-compress-manpage.patch" )
