# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="Python bindings for Augeas"
HOMEPAGE="http://augeas.net/"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"

RDEPEND="
	app-admin/augeas
	>=dev-python/cffi-1.0.0[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}/remove-tests.patch" )

python_test() {
	cd test || die
	"${EPYTHON}" test_augeas.py || die "Tests failed with ${EPYTHON}"
}
