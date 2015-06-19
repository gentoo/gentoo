# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/libvirt-python/libvirt-python-9999.ebuild,v 1.4 2014/12/13 12:52:24 tamiko Exp $

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
	KEYWORDS="~amd64 ~x86"
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

python_test() {
	esetup.py test
}
