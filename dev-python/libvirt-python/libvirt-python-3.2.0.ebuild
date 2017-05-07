# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5} )

MY_P="${P/_rc/-rc}"

inherit distutils-r1

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://libvirt.org/libvirt-python.git"
	SRC_URI=""
	KEYWORDS="amd64"
	RDEPEND="app-emulation/libvirt:=[-python(-)]"
else
	SRC_URI="http://libvirt.org/sources/python/${MY_P}.tar.gz"
	KEYWORDS="amd64 ~x86"
	RDEPEND="app-emulation/libvirt:0/${PV}"
fi
S="${WORKDIR}/${P%_rc*}"

DESCRIPTION="libvirt Python bindings"
HOMEPAGE="https://www.libvirt.org"
LICENSE="LGPL-2"
SLOT="0"
IUSE="examples test"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	test? ( dev-python/lxml[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}] )"

python_test() {
	esetup.py test
}

python_install_all() {
	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
	distutils-r1_python_install_all
}
