# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{7,8} )

inherit distutils-r1 readme.gentoo-r1

DESCRIPTION="Update and verify unofficial Clam Anti-Virus signatures"
HOMEPAGE="https://github.com/rseichter/fangfrisch https://pypi.org/project/fangfrisch/"
SRC_URI="https://github.com/rseichter/fangfrisch/archive/${PV}.tar.gz -> ${P}.tar.gz"

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

You can now enable /etc/cron.d/${PN} for periodic updates.

### Alternative: Updating from release 1.0.1:

Either create a fresh database or manually delete all existing
database tables, then run the initdb command as shown above."

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=">=dev-python/requests-2.22.0[${PYTHON_USEDEP}]
	>=dev-python/sqlalchemy-1.3.11[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

python_prepare_all() {
	sed -i -e '/SQLAlchemy/d' setup.py || die
	# Due to the nature of Fangfrisch, most tests require network
	# connectivity. Upstream CI reports show that the tests are
	# successful, so instead of a pick-and-choose approach, the
	# complete tests directory is removed in this ebuild.
	if [ -d tests ]; then
		rm -r tests || die
	fi
	distutils-r1_python_prepare_all
}

python_install_all() {
	insinto /etc
	doins "${FILESDIR}/${PN}.conf"
	insinto /etc/cron.d
	newins "${FILESDIR}/${PN}.cron" ${PN}
	distutils-r1_python_install_all
	readme.gentoo_create_doc
}

pkg_postinst() {
	FORCE_PRINT_ELOG=1 readme.gentoo_print_elog
}
