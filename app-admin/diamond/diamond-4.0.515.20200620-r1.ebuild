# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ ${PV} = 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/grobian/Diamond.git"
	EGIT_BRANCH="python3"
	S=${WORKDIR}/diamond-${PV}
else
	GHASH=8d8a2e49d80d44968a34d43e36c1d864695a29c1  # from python3 branch
	SRC_URI="https://github.com/grobian/Diamond/archive/${GHASH}.tar.gz -> python-diamond-${PV}.tar.gz"
	KEYWORDS="~amd64 ~arm ~x86 ~amd64-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
	S=${WORKDIR}/Diamond-${GHASH}
fi

PYTHON_COMPAT=( python3_{7,8} )

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
	mysql? ( dev-python/mysqlclient )
	snmp? ( dev-python/pysnmp )
	redis? ( dev-python/redis-py )
	!kernel_linux? ( >=dev-python/psutil-3 )
	kernel_linux? ( sys-process/psmisc )"
DEPEND="${RDEPEND}
	test? ( dev-python/mock )"

src_prepare() {
	# adjust for Prefix
	hprefixify bin/diamond*

	# fix the version (not set in GitHub archive)
	sed -i -e "s/__VERSIONTOKENHERE__/${PV}/" src/diamond/version.py.tmpl || die
	echo "${PV}" > version.txt || die
	# fix symlink out of place
	rm README.md || die
	cp docs/index.md README.md || die

	# this module isn't Python3 yet (lambda), if you use this and have a
	# fix, let me know
	rm src/diamond/handler/rrdtool.py || die

	distutils-r1_src_prepare
}

python_test() {
	"${PYTHON}" ./test.py || die "Tests fail with ${PYTHON}"
}

python_install() {
	export VIRTUAL_ENV=1
	distutils-r1_python_install
	python_optimize
	# since python3.8 installation goes straight into /etc
	[[ -d ${ED}/etc ]] && [[ -d ${ED}/usr/etc ]] && rm -Rf "${ED}"/usr/etc
	if [[ -d ${ED}/usr/etc ]] ; then
		mv "${ED}"/usr/etc "${ED}"/ || die
	fi
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
