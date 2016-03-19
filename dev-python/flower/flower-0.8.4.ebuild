# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_4} )

inherit distutils-r1 systemd user

DESCRIPTION="Real-time monitor and web admin for Celery distributed task queue"
HOMEPAGE="https://${PN}.readthedocs.org/ https://github.com/mher/${PN}/ https://pypi.python.org/pypi/${PN}"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="test"

RDEPEND=">=dev-python/celery-3.1.0[${PYTHON_USEDEP}]
	>=www-servers/tornado-4.2.0[${PYTHON_USEDEP}]
	>=dev-python/pytz-2015.7[${PYTHON_USEDEP}]
	>=dev-python/Babel-2.2.0[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]"

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 /dev/null ${PN}
}

src_prepare() {
	sed -e 's:babel==2.2.0:babel>=2.2.0:' \
		-e 's:pytz==2015.7:pytz>=2015.7:' \
		-e 's:tornado==4.2.0:tornado>=4.2.0:' \
		-i flower.egg-info/requires.txt requirements/default.txt || die
}

src_install() {
	distutils-r1_src_install
	insinto /etc/flower
	doins "${FILESDIR}/config.py"
	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"
	systemd_dounit "${FILESDIR}/${PN}.service"
	keepdir /var/log/${PN}
	fowners ${PN}:${PN} /var/log/${PN}
}

python_test() {
	esetup.py test || die
}
