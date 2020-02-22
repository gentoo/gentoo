# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{7,8} )

inherit distutils-r1 readme.gentoo-r1

DESCRIPTION="Update and verify unofficial Clam Anti-Virus signatures"
HOMEPAGE="https://github.com/rseichter/fangfrisch https://pypi.org/project/fangfrisch/"
SRC_URI="https://github.com/rseichter/fangfrisch/archive/${PV}.tar.gz -> ${P}.tar.gz"
DOC_CONTENTS="
Before enabling /etc/cron.d/${PN} you need to configure Fangfrisch and
manually run the 'initdb' command once.

See https://rseichter.github.io/fangfrisch/ for more information.
"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=">=dev-python/requests-2.22.0[${PYTHON_USEDEP}]
	>=dev-python/sqlalchemy-1.3.11[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

distutils_enable_tests unittest

python_prepare_all() {
	sed -i -e '/SQLAlchemy/d' setup.py || die
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
