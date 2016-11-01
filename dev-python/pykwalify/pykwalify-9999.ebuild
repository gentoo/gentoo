# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_4} )

inherit distutils-r1 git-r3

DESCRIPTION="Python lib/cli for JSON/YAML schema validation"
HOMEPAGE="https://pypi.python.org/pypi/pykwalify https://github.com/Grokzen/pykwalify"
SRC_URI=""
EGIT_REPO_URI="https://github.com/Grokzen/pykwalify.git"

SLOT="0"
LICENSE="MIT"
KEYWORDS=""
IUSE="test"

RDEPEND="
	>=dev-python/docopt-0.6.2
	>=dev-python/pyyaml-3.11
	>=dev-python/python-dateutil-2.4.2
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/testfixtures[${PYTHON_USEDEP}]
	)
"

PATCHES=( "${FILESDIR}"/${PN}-1.4.0-S.patch )

python_test() {
	py.test || die
}
