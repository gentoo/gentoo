# Copyright 2020-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..12} )
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_EXT=1
inherit distutils-r1 pypi

DESCRIPTION="Python bindings for sci-mathematics/lrcalc"
HOMEPAGE="https://bitbucket.org/asbuch/lrcalc"
# Avoid a name clash with the sci-mathematics/lrcalc tarball
SRC_URI="$(pypi_sdist_url) -> ${PN}_python-${PV}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

BDEPEND="dev-python/cython[${PYTHON_USEDEP}]"
DEPEND="~sci-mathematics/lrcalc-${PV}"
RDEPEND="${DEPEND}"

src_prepare() {
	# Fix this typo in setup.py to avoid a QA warning
	sed -i setup.py \
		-e 's/long_description_type/long_description_content_type/' \
		|| die
	default
}
