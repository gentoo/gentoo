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

Modify ${MY_CONF} according to your preferences.
Assuming you place the database into ${MY_DBDIR}
(recommended), execute the following commands in a root shell:

mkdir -m 0770 ${MY_DBDIR}
chgrp clamav ${MY_DBDIR}
sudo -u clamav -- fangfrisch -c ${MY_CONF} initdb

You can now enable /etc/cron.d/${PN} for periodic updates."

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
DOCS=(docs/fangfrisch.pdf)
HTML_DOCS=(docs/index.html)

DEPEND="
	>=dev-python/requests-2.22.0[${PYTHON_USEDEP}]
	>=dev-python/sqlalchemy-1.4.0[${PYTHON_USEDEP}]
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
}

pkg_postinst() {
	readme.gentoo_print_elog
}
