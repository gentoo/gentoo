# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=pyproject.toml
PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="URL normalization for Python"
HOMEPAGE="
	https://github.com/niksite/url-normalize/
	https://pypi.org/project/url-normalize/"
SRC_URI="
	https://github.com/niksite/url-normalize/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="dev-python/six[${PYTHON_USEDEP}]"

distutils_enable_tests pytest

src_prepare() {
	# remove problematic pytest options
	rm tox.ini || die
	distutils-r1_src_prepare
}
