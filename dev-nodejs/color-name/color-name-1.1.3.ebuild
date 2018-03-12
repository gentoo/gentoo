# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A JSON with color names"
HOMEPAGE="https://github.com/colorjs/color-name"
SRC_URI="https://github.com/colorjs/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="net-libs/nodejs"
RDEPEND="${DEPEND}"

src_install() {
	insinto "/usr/$(get_libdir)/node_modules/${PN}"
	doins -r *.js
	doins package.json
}

src_test() {
	/usr/bin/node test.js
}
