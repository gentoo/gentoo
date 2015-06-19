# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/python-etcd/python-etcd-0.3.2.ebuild,v 1.2 2015/04/08 08:05:10 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1

DESCRIPTION="A python client for etcd"
HOMEPAGE="https://github.com/jplana/python-etcd"
SRC_URI="https://github.com/jplana/python-etcd/archive/${PV}.zip -> ${P}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~arm-linux ~x86-linux"
IUSE=""

RDEPEND="
	>=dev-python/urllib3-1.7[${PYTHON_USEDEP}]
	>=dev-python/pyopenssl-0.14[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
