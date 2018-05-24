# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Terminal string styling done right"
HOMEPAGE="https://github.com/chalk/chalk"
SRC_URI="https://github.com/chalk/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=net-libs/nodejs-4.8.7"
RDEPEND="${DEPEND}
	>=dev-nodejs/ansi-styles-3.2.1
	>=dev-nodejs/escape-string-regexp-1.0.5
	>=dev-nodejs/supports-color-5.3.0"

src_install() {
	insinto "/usr/$(get_libdir)/node_modules/${PN}"
	doins -r types
	doins index.js
	doins templates.js
	doins package.json
}