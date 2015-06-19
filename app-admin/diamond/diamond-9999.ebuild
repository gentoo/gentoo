# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/diamond/diamond-9999.ebuild,v 1.4 2015/04/08 07:30:34 mgorny Exp $

EAPI=5

if [[ ${PV} = 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/python-diamond/Diamond.git"
	S=${WORKDIR}/diamond-${PV}
else
	SRC_URI="https://github.com/python-diamond/Diamond/archive/v${PV}.tar.gz -> python-diamond-${PV}.tar.gz"
	KEYWORDS="~x86 ~amd64"
	S=${WORKDIR}/Diamond-${PV}
fi

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Python daemon that collects and publishes system metrics"
HOMEPAGE="https://github.com/python-diamond/Diamond"

LICENSE="MIT"
SLOT="0"
IUSE="test mongo mysql snmp redis"

RDEPEND="dev-python/configobj
	dev-python/setproctitle
	mongo? ( dev-python/pymongo )
	mysql? ( dev-python/mysql-python )
	snmp? ( dev-python/pysnmp )
	redis? ( dev-python/redis-py )"
DEPEND="${RDEPEND}
	test? ( dev-python/mock )"

src_prepare() {
	# adjust for Prefix
	sed -i \
		-e '/default="\/etc\/diamond\/diamond.conf"/s:=":="'"${EPREFIX}"':' \
		bin/diamond* \
		|| die

	distutils-r1_src_prepare
}

python_test() {
	"${PYTHON}" ./test.py || die "Tests fail with ${PYTHON}"
}

python_install() {
	export VIRTUAL_ENV=1
	distutils-r1_python_install
	mv "${ED}"/usr/etc "${ED}"/ || die
	rm "${ED}"/etc/diamond/*.windows  # won't need these
	sed -i \
		-e '/pid_file =/s:/var/run:/run:' \
		"${ED}"/etc/diamond/diamond.conf.example || die
}

src_install() {
	distutils-r1_src_install
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	keepdir /var/log/diamond
}
