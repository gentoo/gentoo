# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )
inherit distutils-r1

DESCRIPTION="A specialized XML reader to navigate C++ declarations"
HOMEPAGE="https://github.com/CastXML/pygccxml"
SRC_URI="https://github.com/CastXML/${PN}/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="Boost-1.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~riscv ~x86"

RDEPEND="
	${PYTHON_DEPS}
	dev-libs/castxml
"
DEPEND="${RDEPEND}"

distutils_enable_tests unittest
distutils_enable_sphinx docs dev-python/sphinx-rtd-theme

python_prepare_all() {
	eapply -p0 "${FILESDIR}/${PN}-2.4.0-pyproject.patch"
	eapply_user

	distutils-r1_python_prepare_all
}
