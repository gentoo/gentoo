# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_6 )

inherit distutils-r1

DESCRIPTION="The Riak client for Python."
HOMEPAGE="https://github.com/basho/riak-python-client/"
MY_PN=${PN%%-*}
MY_P=${MY_PN}-${PV}
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-python/basho-erlastic[${PYTHON_USEDEP}]
	dev-python/protobuf-python[${PYTHON_USEDEP}]
	>=dev-python/six-1.8[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

S=${WORKDIR}/${MY_P}

src_prepare() {
	default
	# delete protobuf requirements that only work for pip
	sed '17,22d' -i setup.py || die
	sed -e "s:'\\\\n\\\\027:b\\0:" \
		-e "s:serialized_pb=:\\0b:" \
		-i riak/pb/*.py || die
}

python_test() {
	esetup.py test || die
}
