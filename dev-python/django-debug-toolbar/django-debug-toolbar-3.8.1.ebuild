# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{9..11} )
inherit distutils-r1

DESCRIPTION="A configurable set of panels that display various debug information"
HOMEPAGE="https://pypi.org/project/django-debug-toolbar/"
SRC_URI="https://github.com/jazzband/${PN}/archive/refs/tags/${PV}.tar.gz
	-> ${P}.gh.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-python/django[${PYTHON_USEDEP}]"

python_test() {
	"${EPYTHON}" -m django test -v 2 --settings tests.settings \
		|| die "Tests failed with ${EPYTHON}"
}
