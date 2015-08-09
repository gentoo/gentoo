# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1

DESCRIPTION="Python library for the Simple and Fast Multimedia Library (SFML)"
HOMEPAGE="http://sfml.sourceforge.net/"
SRC_URI="mirror://sourceforge/sfml/SFML-${PV}-python-sdk.zip"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples"

DEPEND="~media-libs/libsfml-${PV}"
RDEPEND="${DEPEND}"

S=${WORKDIR}/SFML-${PV}/python

python_compile() {
	if [[ ${EPYTHON} == python2* ]] ; then
		local CFLAGS="${CFLAGS} -fno-strict-aliasing"
		export CFLAGS
	fi

	distutils-r1_python_compile
}

python_install_all() {
	distutils-r1_python_install_all
	use doc && dohtml doc/*

	if use examples ; then
		insinto /usr/share/doc/${PF}/examples
		doins -r samples/* || die "doins failed"
	fi
}
