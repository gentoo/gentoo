# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 readme.gentoo-r1 systemd

DESCRIPTION="Update and verify unofficial Clam Anti-Virus signatures"
HOMEPAGE="https://github.com/rseichter/fangfrisch https://pypi.org/project/fangfrisch/"
SRC_URI="https://github.com/rseichter/fangfrisch/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"

MY_CONF="/etc/${PN}.conf"
MY_DBDIR="/var/lib/${PN}"
DISABLE_AUTOFORMATTING=1
DOC_CONTENTS="See https://rseichter.github.io/fangfrisch/ for the official
documentation.

### Fresh installations:

You can now enable /etc/cron.d/${PN} for periodic updates or
systemctl enable --now ${PN}.timer"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
DOCS=(docs/fangfrisch.pdf)
HTML_DOCS=(docs/index.html)

DEPEND="
	>=dev-python/requests-2.22.0[${PYTHON_USEDEP}]
	>=dev-python/sqlalchemy-1.4.0[${PYTHON_USEDEP},sqlite]
"
RDEPEND="${DEPEND}"

distutils_enable_tests unittest

python_install_all() {
	insinto /etc
	doins "${FILESDIR}/${PN}.conf"
	insinto /etc/cron.d
	newins "${FILESDIR}/${PN}.cron" "${PN}"
	exeinto /etc
	doexe "${FILESDIR}/${PN}-has-news.sh"
	systemd_dounit "${FILESDIR}/${PN}.service"
	systemd_dounit "${FILESDIR}/${PN}.timer"
	distutils-r1_python_install_all
	readme.gentoo_create_doc

	keepdir "${MY_DBDIR}"
	fowners clamav:clamav "${MY_DBDIR}"
}

pkg_postinst() {
	readme.gentoo_print_elog
	if [[ ! -e "${EROOT}${MY_DBDIR}/db.sqlite" ]]; then
		elog
		elog "Execute the following command to finish installation:"
		elog
		elog "# emerge --config \"=${CATEGORY}/${PF}\""
	fi
}

pkg_config() {
	einfo
	einfo "Initializing database."
	einfo

	fangfrisch -c "${MY_CONF}" initdb
	chown clamav:clamav "${MY_DBDIR}/db.sqlite"
}
