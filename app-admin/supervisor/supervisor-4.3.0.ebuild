# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )
# xml.etree.ElementTree module required.
PYTHON_REQ_USE="xml(+)"

inherit distutils-r1 pypi systemd

DESCRIPTION="A system for controlling process state under UNIX"
HOMEPAGE="https://supervisord.org/ https://pypi.org/project/supervisor/"

LICENSE="repoze ZPL BSD HPND GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~riscv x86"

RDEPEND="acct-group/supervisor"

PATCHES=(
	# https://github.com/Supervisor/supervisor/issues/1560
	"${FILESDIR}"/${PN}-4.3.0-fix-setuptools-warnings.patch
)

distutils_enable_sphinx docs
distutils_enable_tests pytest

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
