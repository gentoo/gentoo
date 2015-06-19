# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/taskcoach/taskcoach-1.3.40.ebuild,v 1.3 2015/04/08 07:30:30 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 eutils versionator

MY_PN="TaskCoach"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Simple personal tasks and todo lists manager"
HOMEPAGE="http://www.taskcoach.org http://pypi.python.org/pypi/TaskCoach"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE="libnotify"
DEPEND=">=dev-python/wxpython-2.8.9.2:2.8[${PYTHON_USEDEP}]
	>=dev-python/twisted-core-10.0"
RDEPEND="${DEPEND}
	libnotify? ( dev-python/notify-python[${PYTHON_USEDEP}] )"

S="${WORKDIR}/${MY_P}"

DOCS=( CHANGES.txt README.txt )

python_install_all() {
	distutils-r1_python_install_all

	doicon "icons.in/${PN}.png"
	make_desktop_entry ${PN}.py "Task Coach" ${PN} Office
}

pkg_postinst() {
	if [[ -n ${REPLACING_VERSIONS} ]]; then
		if ! version_is_at_least 1.3.40 ${REPLACING_VERSIONS}; then
			elog "Since version 1.3.40, the Task Coach executable is called ${PN}.py"
		fi
	fi
}
