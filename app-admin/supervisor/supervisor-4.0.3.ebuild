# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_{6,7}} )
# xml.etree.ElementTree module required.
PYTHON_REQ_USE="xml(+)"

inherit distutils-r1 systemd user

MY_PV="${PV/_beta/b}"

DESCRIPTION="A system for controlling process state under UNIX"
HOMEPAGE="http://supervisord.org/ https://pypi.org/project/supervisor/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${PN}-${MY_PV}.tar.gz"

LICENSE="repoze ZPL BSD HPND GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/meld3-1.0.0[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? (
		${RDEPEND}
		dev-python/mock[${PYTHON_USEDEP}]
	)
"

S="${WORKDIR}/${PN}-${MY_PV}"

python_compile_all() {
	if use doc; then
		emake -C docs html
		HTML_DOCS=( docs/.build/html/. )
	fi
}

python_test() {
	esetup.py test
}

python_install_all() {
	distutils-r1_python_install_all
	newinitd "${FILESDIR}/init.d-r2" supervisord
	newconfd "${FILESDIR}/conf.d-r1" supervisord
	dodoc supervisor/skel/sample.conf
	keepdir /etc/supervisord.d
	insinto /etc
	doins "${FILESDIR}/supervisord.conf"
	keepdir /var/log/supervisor
	systemd_dounit "${FILESDIR}/supervisord.service"
}

pkg_preinst() {
	enewgroup supervisor
	fowners :supervisor /var/log/supervisor
	fperms 750 /var/log/supervisor
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		# This is a new installation
		elog "You may install your configuration files in ${EROOT}/etc/supervisord.d"
		elog "For config examples, see ${EROOT}/usr/share/doc/${PF}/sample.conf.bz2"
		elog ""
		elog "By default, only members of the supervisor group can run supervisorctl."
	fi
}
