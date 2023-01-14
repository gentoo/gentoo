# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="Python CRC Generator module"
HOMEPAGE="http://crcmod.sourceforge.net/"
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
