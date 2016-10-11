# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Golden Disk Image builder."
HOMEPAGE="http://docs.openstack.org/developer/diskimage-builder/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

CDEPEND=">=dev-python/pbr-1.6[${PYTHON_USEDEP}]"
DEPEND="${CDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="${CDEPEND}
	>=dev-python/Babel-2.3.4[${PYTHON_USEDEP}]
	dev-python/dib-utils[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-3.10.0[${PYTHON_USEDEP}]
	>=dev-python/flake8-2.5.4[${PYTHON_USEDEP}]
	<dev-python/flake8-2.6.0[${PYTHON_USEDEP}]
	>=dev-python/six-1.9.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-sphinx-4.7.0[${PYTHON_USEDEP}]
	app-emulation/qemu
	sys-block/parted
	sys-fs/multipath-tools"
