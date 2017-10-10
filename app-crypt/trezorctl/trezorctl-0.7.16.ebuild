# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )
inherit distutils-r1 bash-completion-r1

DESCRIPTION="Client side implementation for TREZOR-compatible Bitcoin hardware wallets"
HOMEPAGE="https://trezor.io/"
SRC_URI="https://github.com/trezor/python-trezor/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-python/ecdsa-0.9[${PYTHON_USEDEP}]
	>=dev-python/protobuf-python-3.1.0[${PYTHON_USEDEP}]
	>=dev-python/mnemonic-0.17[${PYTHON_USEDEP}]
	>=dev-python/hidapi-0.7.99_p20[${PYTHON_USEDEP}]
	>=dev-python/requests-2.4.0[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"

S="${WORKDIR}/python-trezor-${PV}"

python_install_all() {
	newbashcomp bash_completion.d/trezorctl.sh "${PN}"
	distutils-r1_python_install_all
}
