# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1

DESCRIPTION="RESTful HTTP Content Negotiation for Flask, Bottle, web.py and webapp2"
HOMEPAGE="
	https://pypi.org/project/mimerender/
	https://github.com/martinblech/mimerender/"
SRC_URI="
	https://github.com/martinblech/mimerender/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm64 x86"

RDEPEND="dev-python/python-mimeparse[${PYTHON_USEDEP}]"

distutils_enable_tests unittest

python_test() {
	"${EPYTHON}" src/test.py -v || die "Tests fail with ${EPYTHON}"
}
