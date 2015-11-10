# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 python3_4 )

inherit distutils-r1 eutils vcs-snapshot

DESCRIPTION="DataStax python driver for Apache Cassandra"
HOMEPAGE="https://github.com/datastax/python-driver https://pypi.python.org/pypi/cassandra-driver/${PV}"
SRC_URI="https://github.com/datastax/python-driver/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="Apache-2.0"

SLOT="0"
KEYWORDS="~amd64"
IUSE="+cython doc +libev +murmur test"

RDEPEND="
	~dev-python/futures-2.2.0
	virtual/python-futures[${PYTHON_USEDEP}]
	>=dev-python/six-1.6[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	cython? (
		>=dev-python/cython-0.20[${PYTHON_USEDEP}]
	)
	doc? (
		dev-python/sphinx[${PYTHON_USEDEP}]
	)
	libev? (
		dev-libs/libev
	)
	test? (
		dev-python/nose[${PYTHON_USEDEP}]
		~dev-python/mock-1.0.1[${PYTHON_USEDEP}]
		dev-python/pytz[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/sure[${PYTHON_USEDEP}]
	)
"

python_configure_all() {
	mydistutilsargs=( $(usex cython "" --no-cython)
					  $(usex libev "" --no-libev)
					  $(usex murmur "" --no-murmur3) )
}

python_compile_all() {
	use doc && esetup.py doc
}

python_test() {
	nosetests -v tests.unit || die "Tests fail with ${EPYTHON}"
}

python_install_all() {
	distutils-r1_python_install_all "${@}"
	use doc && dohtml -r docs/_build/${PV}/.
}

pkg_postinst() {
	einfo
	einfo "Some behaviors of this driver are enabled at run-time"
	einfo "when certain libs are detected.  Compression support is"
	einfo "enabled if dev-python/lz4 or dev-python/snappy are"
	einfo "installed.  Also scales (for metrics) and blist (for"
	einfo "sorted sets) provide additional features, though there"
	einfo "are not packages in the tree yet (install with pip)."
	einfo
}

# TODO
# - dev-python/eventlet and dev-python/gevent appear to be
#   optional runtime deps but the docs never explicitly mention them.
#   Is it maybe the case that one of the two is required, but only
#   if libev is built?
