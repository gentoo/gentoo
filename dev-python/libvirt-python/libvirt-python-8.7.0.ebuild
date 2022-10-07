# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Packages which get releases together:
# app-emacs/nxml-libvirt-schemas
# dev-python/libvirt-python
# dev-perl/Sys-Virt
# app-emulation/libvirt
# Please bump them together!

PYTHON_COMPAT=( python3_{8..11} )
DISTUTILS_USE_PEP517=setuptools
MY_P="${P/_rc/-rc}"
VERIFY_SIG_OPENPGP_KEY_PATH="${BROOT}"/usr/share/openpgp-keys/libvirt.org.asc
inherit distutils-r1 verify-sig

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.com/libvirt/libvirt-python.git"
	RDEPEND="app-emulation/libvirt:=[-python(-)]"
else
	SRC_URI="https://libvirt.org/sources/python/${MY_P}.tar.gz
		verify-sig? ( https://libvirt.org/sources/python/${MY_P}.tar.gz.asc )"
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

BDEPEND="
	virtual/pkgconfig
	test? (
		dev-python/lxml[${PYTHON_USEDEP}]
	)
	verify-sig? ( sec-keys/openpgp-keys-libvirt )
"

distutils_enable_tests pytest

python_install_all() {
	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi

	distutils-r1_python_install_all
}
