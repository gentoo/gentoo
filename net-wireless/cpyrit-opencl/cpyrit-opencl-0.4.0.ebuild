# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

PYTHON_DEPEND="2:2.5"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils eutils

DESCRIPTION="A sub-package that adds OpenCL-capability to Pyrit"
HOMEPAGE="https://code.google.com/p/pyrit/"
SRC_URI="https://pyrit.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-libs/openssl
	sys-libs/zlib
	virtual/opencl"
RDEPEND="${DEPEND}"
PDEPEND="~net-wireless/pyrit-${PV}"
