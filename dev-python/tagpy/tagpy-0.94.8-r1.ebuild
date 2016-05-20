# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="2.5 3.* *-jython 2.7-pypy-*"

inherit distutils eutils

DESCRIPTION="Python Bindings for TagLib"
HOMEPAGE="http://mathema.tician.de//software/tagpy https://pypi.python.org/pypi/tagpy"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 ~sparc x86"
IUSE="examples"

RDEPEND=">=dev-libs/boost-1.48[python,threads]
	>=media-libs/taglib-1.4"
DEPEND="${RDEPEND}
	dev-python/setuptools"

DISTUTILS_USE_SEPARATE_SOURCE_DIRECTORIES="1"

src_prepare() {
	# bug #440740
	epatch "${FILESDIR}"/${P}-taglib-1.8_compat.patch

	# Disable broken check for Distribute.
	sed -e "s/if 'distribute' not in setuptools.__file__:/if False:/" -i aksetup_helper.py

	distutils_src_prepare
}

src_configure() {
	configuration() {
		"$(PYTHON)" configure.py \
			--taglib-inc-dir="${EPREFIX}/usr/include/taglib" \
			--boost-python-libname="boost_python-${PYTHON_ABI}-mt"
	}
	python_execute_function -s configuration
}

src_install() {
	distutils_src_install

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins test/*
	fi
}
