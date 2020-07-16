# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=1

inherit toolchain-funcs distutils-r1 eapi7-ver

DESCRIPTION="A sub-package that adds CUDA-capability to Pyrit"
HOMEPAGE="https://github.com/JPaulMora/Pyrit"
SRC_URI="https://github.com/JPaulMora/Pyrit/archive/v${PV}.tar.gz -> pyrit-${PV}.tar.gz"

LICENSE="GPL-3+ GPL-3+-with-cuda-exception GPL-3+-with-cuda-openssl-exception"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	dev-libs/openssl:=
	net-libs/libpcap
	dev-util/nvidia-cuda-toolkit"
RDEPEND="${DEPEND}"
PDEPEND="~net-wireless/pyrit-${PV}"

S="${WORKDIR}/Pyrit-${PV}/modules/cpyrit_cuda"

pkg_pretend() {
	if tc-is-gcc && ver_test $(gcc-version) -ge 4.8; then
		die "gcc 4.8 and up are not supported"
	fi
}

pkg_setup() {
	python-single-r1_pkg_setup
}
