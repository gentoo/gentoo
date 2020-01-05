# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_6,3_7} )

MY_P="${P/_rc/-rc}"

inherit distutils-r1

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://libvirt.org/git/libvirt-python.git"
	SRC_URI=""
	KEYWORDS="amd64 x86"
	RDEPEND="app-emulation/libvirt:=[-python(-)]"
else
	SRC_URI="https://libvirt.org/sources/python/${MY_P}.tar.gz"
	KEYWORDS="amd64 ~arm64 ~ppc64 x86"
	RDEPEND="app-emulation/libvirt:0/${PV}"
fi
S="${WORKDIR}/${P%_rc*}"

DESCRIPTION="libvirt Python bindings"
HOMEPAGE="https://www.libvirt.org"
LICENSE="LGPL-2"
SLOT="0"
IUSE="examples test"
RESTRICT="!test? ( test )"

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
