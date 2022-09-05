# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="Stylesheet Generator for PyQt5/PySide2"
HOMEPAGE="https://github.com/blambright/qstylizer"
SRC_URI="https://github.com/blambright/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-python/tinycss2-0.5[${PYTHON_USEDEP}]
	<dev-python/tinycss2-2[${PYTHON_USEDEP}]
	>=dev-python/inflection-0.3.0[${PYTHON_USEDEP}]
	<dev-python/inflection-1[${PYTHON_USEDEP}]
"

BDEPEND="
	dev-python/pbr[${PYTHON_USEDEP}]
	dev-vcs/git
	test? (
		dev-python/pytest-mock[${PYTHON_USEDEP}]
		dev-python/pytest-xdist[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
distutils_enable_sphinx doc dev-python/sphinx_rtd_theme dev-python/sphinxcontrib-autoprogram

python_prepare_all() {
	# Exception: Versioning for this project requires either an sdist tarball, or access to an
	# upstream git repository. It's also possible that there is a mismatch between the package
	# name in setup.cfg and the argument given to pbr.version.VersionInfo. Project name qstylizer
	# was given, but was not able to be found.
	#
	# There are no tarballs on PyPI, so we do this as a workaround
	git init -q || die
	git config user.email "larry@gentoo.org" || die
	git config user.name "Larry the Cow" || die
	git add . || die
	git commit -m "init" || die
	git tag -a "${PV}" -m "${PV}" || die

	distutils-r1_python_prepare_all
}
