# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
DISTUTILS_USE_PEP517=flit

inherit distutils-r1

MY_PN="solo1"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="CLI and Python library for SoloKeys Solo 1"
HOMEPAGE="https://github.com/solokeys/solo1-cli"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="Apache-2.0 MIT"
SLOT="0"
KEYWORDS="~amd64 ~riscv"

RDEPEND=">=dev-python/click-7.1.0[${PYTHON_USEDEP}]
	dev-python/cryptography[${PYTHON_USEDEP}]
	dev-python/ecdsa[${PYTHON_USEDEP}]
	>=dev-python/fido2-0.9.1[${PYTHON_USEDEP}]
	dev-python/intelhex[${PYTHON_USEDEP}]
	dev-python/pyserial[${PYTHON_USEDEP}]
	dev-python/pyusb[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]"

S="${WORKDIR}"/${MY_P}

pkg_postinst() {
	if [[ -n ${REPLACING_VERSIONS} ]]; then
		local ver
		for ver in ${REPLACING_VERSIONS}; do
			if ver_test ${ver} -lt 0.1.1; then
				ewarn "Note that since version 0.1.1 the CLI executable is called '${MY_PN}' rather than 'solo'"
				ewarn "The old name can still be used for now but is deprecated"
				break
			fi
		done
	fi
}
