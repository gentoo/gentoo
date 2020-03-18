# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1

DESCRIPTION="GLEP 63 compliance checker for OpenPGP keys"
HOMEPAGE="https://github.com/mgorny/glep63-check/"
SRC_URI="https://github.com/mgorny/glep63-check/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="!test? ( test )"

RDEPEND="app-crypt/gnupg"
DEPEND="
	test? (
		${RDEPEND}
		sys-libs/libfaketime
	)"

python_test() {
	"${EPYTHON}" -m unittest -v || die "Tests fail with ${EPYTHON}"
}
