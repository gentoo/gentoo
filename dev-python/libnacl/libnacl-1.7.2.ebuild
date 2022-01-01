# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=(python3_{6..9})
inherit distutils-r1

DESCRIPTION="Python ctypes wrapper for libsodium"
HOMEPAGE="https://libnacl.readthedocs.org/"
SRC_URI="https://github.com/saltstack/libnacl/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm ~x86"

RDEPEND="dev-libs/libsodium"
BDEPEND="${RDEPEND}"

python_test() {
	"${EPYTHON}" -m unittest discover -v -p 'test_*.py' tests/ || die "Tests failed with ${EPYTHON}"
}
