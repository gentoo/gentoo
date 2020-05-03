# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( pypy3 python3_{6,7,8} )
# xml.etree.ElementTree module required.
PYTHON_REQ_USE="xml(+)"
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1 systemd

MY_PV="${PV/_beta/b}"

DESCRIPTION="A system for controlling process state under UNIX"
HOMEPAGE="http://supervisord.org/ https://pypi.org/project/supervisor/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${PN}-${MY_PV}.tar.gz"
S="${WORKDIR}/${PN}-${MY_PV}"

LICENSE="repoze ZPL BSD HPND GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="acct-group/supervisor"

distutils_enable_sphinx docs
distutils_enable_tests pytest

python_prepare_all() {
	# Skip one test that currently fails
	# https://github.com/Supervisor/supervisor/issues/1346
	sed -i 's/test_prepare_socket/_&/' \
		supervisor/tests/test_socket_manager.py || die
	distutils-r1_python_prepare_all
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
