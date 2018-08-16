# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{4,5,6,7} )

inherit python-single-r1

DESCRIPTION="GLEP 63 compliance checker for OpenPGP keys"
HOMEPAGE="https://github.com/mgorny/glep63-check/"
SRC_URI="https://github.com/mgorny/glep63-check/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	app-crypt/gnupg"

src_compile() {
	python_fix_shebang glep63-check
}

src_install() {
	dobin glep63-check
}
