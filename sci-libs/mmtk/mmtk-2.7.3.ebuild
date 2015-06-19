# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/mmtk/mmtk-2.7.3.ebuild,v 1.6 2014/10/24 10:13:26 jlec Exp $

EAPI=5

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.* 2.7-pypy-* *-jython"

inherit distutils

# This number identifies each release on the CRU website.
# Can't figure out how to avoid hardcoding it.
NUMBER="3421"

MY_PN=${PN/mmtk/MMTK}
MY_P=${MY_PN}-${PV}

PYTHON_MODNAME="${MY_PN}"

DESCRIPTION="Molecular Modeling ToolKit for Python"
HOMEPAGE="http://dirac.cnrs-orleans.fr/MMTK/"
SRC_URI="http://sourcesup.cru.fr/frs/download.php/${NUMBER}/${MY_P}.tar.gz"

SLOT="0"
LICENSE="CeCILL-2"
KEYWORDS="~amd64 ~x86 ~ppc ~amd64-linux ~x86-linux"
IUSE="examples"

RDEPEND="
	dev-python/cython
	<dev-python/numpy-1.9
	dev-python/scientificpython"
DEPEND="${RDEPEND}"

S="${WORKDIR}"/${MY_P}

src_prepare() {
	export MMTK_USE_CYTHON="1"
	sed -i -e "/ext_package/d" \
		"${S}"/setup.py \
		|| die
	distutils_src_prepare
}

src_install() {
	distutils_src_install

	dodoc README* Doc/CHANGELOG
	dohtml -r Doc/HTML/*

	if use examples; then
		insinto /usr/share/${P}
		doins -r Examples
	fi
}
