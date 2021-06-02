# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

DISTUTILS_USE_SETUPTOOLS=no

MY_P="${P/_rc/-rc}"

inherit distutils-r1 verify-sig

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://libvirt.org/git/libvirt-python.git"
	RDEPEND="app-emulation/libvirt:=[-python(-)]"
else
	SRC_URI="https://libvirt.org/sources/python/${MY_P}.tar.gz
		verify-sig? ( https://libvirt.org/sources/python/${MY_P}.tar.gz.asc )"
	KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
	RDEPEND="app-emulation/libvirt:0/${PV}"
fi
S="${WORKDIR}/${P%_rc*}"

DESCRIPTION="libvirt Python bindings"
HOMEPAGE="https://www.libvirt.org"
LICENSE="LGPL-2"
SLOT="0"
VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/libvirt.org.asc
IUSE="examples test"
RESTRICT="!test? ( test )"

BDEPEND="
	virtual/pkgconfig
	test? (
		dev-python/lxml[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
	)
	verify-sig? ( app-crypt/openpgp-keys-libvirt )
"

distutils_enable_tests setup.py

python_install_all() {
	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
	distutils-r1_python_install_all
}
