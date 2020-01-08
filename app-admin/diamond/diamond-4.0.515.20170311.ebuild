# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ ${PV} = 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/python-diamond/Diamond.git"
	S=${WORKDIR}/diamond-${PV}
else
	GHASH=73207d04e0739a4ce92bc201b36681c42d9fa7e7  # python3 branch
	SRC_URI="https://github.com/python-diamond/Diamond/archive/${GHASH}.tar.gz -> python-diamond-${PV}.tar.gz"
	KEYWORDS="~amd64 ~arm ~x86 ~amd64-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
	S=${WORKDIR}/Diamond-${GHASH}
fi

PYTHON_COMPAT=( python3_6 )

inherit distutils-r1 prefix

DESCRIPTION="Python daemon that collects and publishes system metrics"
HOMEPAGE="https://github.com/python-diamond/Diamond"

LICENSE="MIT"
SLOT="0"
IUSE="test mongo mysql snmp redis"
RESTRICT="!test? ( test )"

RDEPEND="dev-python/configobj
	dev-python/setproctitle
	mongo? ( dev-python/pymongo )
	mysql? ( dev-python/mysql-python )
	snmp? ( dev-python/pysnmp )
	redis? ( dev-python/redis-py )
	!kernel_linux? ( >=dev-python/psutil-3 )"
DEPEND="${RDEPEND}
	test? (
		dev-python/mock
		dev-python/pysnmp
	)"

src_prepare() {
	# adjust for Prefix
	hprefixify bin/diamond*

	# fix the version (not set in GitHub archive)
	sed -i -e "s/__VERSIONTOKENHERE__/${PV}/" src/diamond/version.py.tmpl || die
	echo "${PV}" > version.txt || die
	# fix psutil usage
	sed -i -e 's/psutil\.network_io_counters/psutil.net_io_counters/' \
		src/collectors/network/network.py || die
	# fix symlink out of place
	rm README.md || die
	cp docs/index.md README.md || die

	# this module isn't Python3 yet (lambda), if you use this and have a
	# fix, let me know
	rm src/diamond/handler/rrdtool.py || die

	# forgotten conversion
	sed -i \
		-e 's/import Queue/import queue/' \
		-e 's/Queue\.Full/queue.Full/' \
		src/diamond/handler/queue.py || die
	# fix usage of map as list
	sed -i \
		-e '/paths = map(str.strip, paths)/d' \
		src/diamond/utils/classes.py || die
	# send data as bytes
	sed -i \
		-e '/self.socket.sendall/s/data/str.encode(data)/' \
		src/diamond/handler/graphite.py || die

	distutils-r1_src_prepare
}

python_test() {
	# don't want to depend on docker for just this
	mv src/collectors/docker_collector/test/{test,no}docker_collector.py || die
	# fails on binding ports
	mv src/collectors/portstat/tests/{test,no}_portstat.py || die
	"${PYTHON}" ./test.py || die "Tests fail with ${PYTHON}"
}

python_install() {
	export VIRTUAL_ENV=1
	distutils-r1_python_install
	python_optimize
	mv "${ED}"/usr/etc "${ED}"/ || die
	rm "${ED}"/etc/diamond/*.windows  # won't need these
	sed -i \
		-e '/pid_file =/s:/var/run:/run:' \
		"${ED}"/etc/diamond/diamond.conf.example || die
	hprefixify "${ED}"/etc/diamond/diamond.conf.example
}

src_install() {
	distutils-r1_src_install
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	keepdir /var/log/diamond
}
