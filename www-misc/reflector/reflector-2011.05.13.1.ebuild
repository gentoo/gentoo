# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3

DISTUTILS_USE_SEPARATE_SOURCE_DIRECTORIES=1
PYTHON_DEPEND="*:2.6"
RESTRICT_PYTHON_ABIS="2.[45]"
SUPPORT_PYTHON_ABIS=1

inherit eutils distutils

DESCRIPTION="archlinux's take on mirrorselect"
HOMEPAGE="http://xyne.archlinux.ca/projects/reflector/"
SRC_URI="http://xyne.archlinux.ca/src/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

S=${WORKDIR}/${PN}

PYTHON_MODNAME="Reflector.py"

src_prepare() {
	distutils_src_prepare

	my_src_prepare() {
		[[ $(python_get_version --major) == 2 ]] && epatch 3to2.patch
		:
	}

	python_execute_function -s my_src_prepare

	python_convert_shebangs "" ${PN}
}

src_install() {
	distutils_src_install

	dobin ${PN} || die
}
