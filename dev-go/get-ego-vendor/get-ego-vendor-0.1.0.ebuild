# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module

DESCRIPTION="Utility to generate EGO_VENDOR data for ebuilds"
HOMEPAGE="http://github.com/williamh/get-ego-vendor"
SRC_URI="https://github.com/williamh/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

src_compile () {
	go build ||  die
}

src_install () {
dobin get-ego-vendor
dodoc README.md
}
