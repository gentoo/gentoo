# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1

DESCRIPTION="Python CRC Generator module"
HOMEPAGE="https://crcmod.sourceforge.net/"
SRC_URI="
	https://downloads.sourceforge.net/project/crcmod/crcmod/${P}/${P}.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm x86"

DOCS=( changelog test/examples.py )

python_test() {
	"${EPYTHON}" test/test_crcmod.py -v || die "Tests fail with ${EPYTHON}"
}
