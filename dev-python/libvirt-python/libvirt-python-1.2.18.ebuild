# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} )

AUTOTOOLIZE=yes

MY_P="${P/_rc/-rc}"

inherit eutils distutils-r1

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://libvirt.org/libvirt-python.git"
	SRC_URI=""
	KEYWORDS=""
	RDEPEND="app-emulation/libvirt:=[-python(-)]"
else
	SRC_URI="http://libvirt.org/sources/python/${MY_P}.tar.gz"
	KEYWORDS="amd64 x86"
	RDEPEND="app-emulation/libvirt:0/${PV}"
fi
S="${WORKDIR}/${P%_rc*}"

DESCRIPTION="libvirt Python bindings"
HOMEPAGE="http://www.libvirt.org"
LICENSE="LGPL-2"
SLOT="0"
IUSE="test"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	test? ( dev-python/lxml[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}] )"

# testsuite is currently not included in upstream tarball
RESTRICT="test"

python_test() {
	esetup.py test
}
