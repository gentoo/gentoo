# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} )
PYTHON_REQ_USE="ncurses"

inherit distutils-r1 linux-info

MYPN=Glances
MYP=${MYPN}-${PV}

DESCRIPTION="CLI curses based monitoring tool"
HOMEPAGE="https://github.com/nicolargo/glances"
SRC_URI="mirror://pypi/${MYPN:0:1}/${MYPN}/${MYP}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86 ~amd64-linux ~x86-linux"
IUSE="chart doc hddtemp snmp web"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
# There is another optional extra batinfo, absent from portage
RDEPEND="${DEPEND}
	>=dev-python/psutil-2.0.0[${PYTHON_USEDEP}]
	hddtemp? ( app-admin/hddtemp )
	snmp? ( dev-python/pysnmp[${PYTHON_USEDEP}] )
	web? ( dev-python/bottle[${PYTHON_USEDEP}] )
	chart? ( dev-python/matplotlib[${PYTHON_USEDEP}] )"

CONFIG_CHECK="~TASK_IO_ACCOUNTING ~TASK_DELAY_ACCT ~TASKSTATS"

S="${WORKDIR}/${MYP}"

# Remove duplicate entries of a prebuilt doc build and
# ensure install of the file glances.conf in /etc/${PN}
PATCHES=( "${FILESDIR}"/2.4.2-setup-data.patch )

pkg_setup() {
	linux-info_pkg_setup
}

python_install_all() {
	# add an intended file from original data set from setup.py to DOCS
	local DOCS="README.rst conf/glances.conf"
	# setup for pre-built html docs in setup.py
	use doc && local HTML_DOCS=( docs/_build/html/. )

	distutils-r1_python_install_all
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		elog "${PN} can gain additional functionality with following packages:"
		elog "   dev-python/jinja - export statistics to HTML"
		elog "   app-admin/hddtemp - monitor hard drive temperatures"
		elog "   dev-python/pysnmp - enable Python SNMP library support"
		elog "   dev-python/bottle - for Web server mode"
		elog "   dev-python/matplotlib - for graphical / chart support"
	fi
	elog "A copy of glances.conf has been added to DOCS"
}
