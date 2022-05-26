# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="A rewrite of Python's builtin doctest module but without all the weirdness"
HOMEPAGE="https://github.com/Erotemic/xdoctest/"
SRC_URI="
	https://github.com/Erotemic/xdoctest/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

SLOT="0"
LICENSE="Apache-2.0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/six[${PYTHON_USEDEP}]
"
# dev-python/nbformat-5.1.{0..2} did not install package data
BDEPEND="
	test? (
		>=dev-python/nbformat-5.1.2-r1[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
#distutils_enable_sphinx docs/source \
#	dev-python/autoapi \
#	dev-python/sphinx_rtd_theme
