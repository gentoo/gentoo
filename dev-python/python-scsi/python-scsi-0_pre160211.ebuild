# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_6 )

inherit distutils-r1 eutils

HASH="957e5538d8d441fb792db6fbbdc0a5e8d57d9c7d"

DESCRIPTION="Access to SG_IO scsi devices"
HOMEPAGE="https://github.com/rosjat/python-scsi/"
SRC_URI="https://github.com/rosjat/python-scsi/archive/${HASH}.zip -> ${P}.zip"

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

S="${WORKDIR}"/${PN}-${HASH}

pkg_postinst() {
	optfeature "iSCSI support" dev-python/libiscsi-python
}
