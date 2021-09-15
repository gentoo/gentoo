# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
PYTHON_REQ_USE="xml(+)"

inherit distutils-r1

MY_P=${PN,,}-${PV}
DESCRIPTION="Python library for communicating with AMQP peers using Twisted"
HOMEPAGE="https://github.com/txamqp/txamqp"
# pypi tarball misses doc files
# https://github.com/txamqp/txamqp/pull/10
SRC_URI="https://github.com/txamqp/txamqp/archive/${PV}.tar.gz -> ${MY_P}.tar.gz"
S=${WORKDIR}/${MY_P}

LICENSE="Apache-2.0"
KEYWORDS="~amd64 ~x86 ~x64-solaris"
SLOT="0"
IUSE="test"

RDEPEND="
	dev-python/twisted[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		${RDEPEND}
		net-misc/rabbitmq-server
	)"

# Tests connect to the system rabbitmq server
# TODO: figure out how to start an isolated instance
RESTRICT="test"

python_test() {
	cd src || die
	# tests look for those files relatively to modules
	cp -r specs "${BUILD_DIR}"/lib || die

	TXAMQP_BROKER=RABBITMQ trial txamqp
	local ret=${?}

	# avoid installing spec files
	rm -r "${BUILD_DIR}"/lib/specs || die

	[[ ${ret} == 0 ]] || die "Tests failed with ${EPYTHON}"
}

python_install_all() {
	local DOCS=( doc/* )

	distutils-r1_python_install_all
}
