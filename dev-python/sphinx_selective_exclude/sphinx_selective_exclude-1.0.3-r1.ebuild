# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )

DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 pypi

DESCRIPTION="Sphinx selective rendition extensions"
HOMEPAGE="https://github.com/pfalcon/sphinx_selective_exclude"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

PDEPEND="dev-python/sphinx[${PYTHON_USEDEP}]"

PATCHES=( "${FILESDIR}"/${PN}-description-file.patch )
