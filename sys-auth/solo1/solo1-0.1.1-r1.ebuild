# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=flit

inherit distutils-r1 pypi

DESCRIPTION="CLI and Python library for SoloKeys Solo 1"
HOMEPAGE="https://github.com/solokeys/solo1-cli"

LICENSE="Apache-2.0 MIT"
SLOT="0"
KEYWORDS="amd64 ~riscv"

RDEPEND=">=dev-python/click-7.1.0[${PYTHON_USEDEP}]
	dev-python/cryptography[${PYTHON_USEDEP}]
	dev-python/ecdsa[${PYTHON_USEDEP}]
	dev-python/fido2:0/0.9[${PYTHON_USEDEP}]
	dev-python/intelhex[${PYTHON_USEDEP}]
	dev-python/pyserial[${PYTHON_USEDEP}]
	dev-python/pyusb[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]"

pkg_postinst() {
	if [[ -n ${REPLACING_VERSIONS} ]]; then
		local ver
		for ver in ${REPLACING_VERSIONS}; do
			if ver_test ${ver} -lt 0.1.1; then
				ewarn "Note that since version 0.1.1 the CLI executable is called '${PN}' rather than 'solo'"
				ewarn "The old name can still be used for now but is deprecated"
				break
			fi
		done
	fi
}
