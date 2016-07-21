# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 eutils

MY_PN="TaskCoach"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Simple personal tasks and todo lists manager"
HOMEPAGE="http://www.taskcoach.org https://pypi.python.org/pypi/TaskCoach"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="libnotify"
DEPEND=">=dev-python/wxpython-2.8.9.2:2.8[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}
	libnotify? ( dev-python/notify-python[${PYTHON_USEDEP}] )"

S="${WORKDIR}/${MY_P}"

DOCS=( CHANGES.txt README.txt )

python_install_all() {
	distutils-r1_python_install_all

	# a bit ugly but...
	mv "${D}/usr/bin/taskcoach.py" "${D}/usr/bin/taskcoach" || die
	for file in "${D}"/usr/bin/taskcoach.py-*; do
		dir=$(dirname ${file})
		ver=$(basename ${file})
		ver=${ver#taskcoach.py-}
		mv "${file}" "${dir}/taskcoach-${ver}" || die
	done

	doicon "icons.in/${PN}.png"
	make_desktop_entry ${PN} "Task Coach" ${PN} Office
}
