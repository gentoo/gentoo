# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="Use Cache URLs in your Django application"
HOMEPAGE="
	https://github.com/epicserve/django-cache-url/
	https://pypi.org/project/django-cache-url/
"
SRC_URI="
	https://github.com/epicserve/django-cache-url/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~ppc ~ppc64 ~riscv ~sparc x86"

RDEPEND="
	dev-python/django[${PYTHON_USEDEP}]
"

DOCS=( AUTHORS.rst CHANGELOG.rst README.rst )

distutils_enable_tests pytest

python_prepare_all() {
	sed -e '/--cov/d' -i setup.cfg || die
	distutils-r1_python_prepare_all
}
