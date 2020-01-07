# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_6 )

inherit distutils-r1 systemd user

DESCRIPTION="Real-time monitor and web admin for Celery distributed task queue"
HOMEPAGE="https://flower.readthedocs.org/ https://github.com/mher/flower/ https://pypi.org/project/flower/"
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
	eapply_user
	sed -e 's:tornado==4.2.0:tornado>=4.2.0:' \
		-i requirements/default.txt || die
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
	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}.logrotated" "${PN}"
}

python_install() {
	distutils-r1_python_install --install-scripts "${EPREFIX}/usr/libexec/flower"
}

python_test() {
	esetup.py test || die
}
