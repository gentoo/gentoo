# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module

DESCRIPTION="A dead simple, no frills Go cross compile tool"
HOMEPAGE="https://github.com/mitchellh/gox"
SRC_URI="https://github.com/mitchellh/gox/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MPL-2.0"
SLOT="0/${PVR}"
KEYWORDS="amd64"

RESTRICT+=" test"

src_compile() {
	go build -mod=vendor . || die
}

src_install() {
	dobin ${PN}
	einstalldocs
}
