# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1

DESCRIPTION="A sub-package that adds OpenCL-capability to Pyrit"
HOMEPAGE="https://github.com/JPaulMora/Pyrit"
SRC_URI="https://github.com/JPaulMora/Pyrit/archive/v${PV}.tar.gz -> pyrit-${PV}.tar.gz"

LICENSE="GPL-3+ GPL-3+-with-opencl-exception GPL-3+-with-opencl-openssl-exception"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	dev-libs/openssl:=
	sys-libs/zlib
	virtual/opencl"
RDEPEND="${DEPEND}"
PDEPEND="~net-wireless/pyrit-${PV}"

S="${WORKDIR}/Pyrit-${PV}/modules/cpyrit_opencl"

pkg_setup() {
	python-single-r1_pkg_setup
}
