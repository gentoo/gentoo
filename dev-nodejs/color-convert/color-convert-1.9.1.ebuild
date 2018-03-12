# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Plain color conversion functions in JavaScript"
HOMEPAGE="https://github.com/Qix-/color-convert"
SRC_URI="https://github.com/Qix-/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="net-libs/nodejs"
RDEPEND="${DEPEND}
	>=dev-nodejs/color-name-1.1.1"

src_install() {
	insinto "/usr/$(get_libdir)/node_modules/${PN}"
	doins -r *.js
	doins *.json
}