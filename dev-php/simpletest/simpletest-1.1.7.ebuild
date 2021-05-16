# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KEYWORDS="~amd64 ~x86"

DESCRIPTION="A PHP testing framework"
HOMEPAGE="http://www.simpletest.org/"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="LGPL-2.1"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="dev-lang/php:*"

src_install() {
	local DOCS=( docs HELP_MY_TESTS_DONT_WORK_ANYMORE README.md TODO.xml )
	einstalldocs

	insinto "/usr/share/php/${PN}"
	doins -r *.php extensions packages tutorials
}
