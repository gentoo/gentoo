# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_{4,5}} )

inherit distutils-r1

DESCRIPTION="A python client for etcd"
HOMEPAGE="https://github.com/jplana/python-etcd"
SRC_URI="https://github.com/jplana/python-etcd/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~arm-linux ~x86-linux"
IUSE=""

RDEPEND="
	>=dev-python/urllib3-1.7[${PYTHON_USEDEP}]
	>=dev-python/pyopenssl-0.14[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
