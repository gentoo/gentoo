# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="2.4 2.5 3.*"
PYTHON_MODNAME="buildlib taskcoachlib"

inherit distutils eutils

MY_PN="TaskCoach"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Simple personal tasks and todo lists manager"
HOMEPAGE="http://www.taskcoach.org https://pypi.python.org/pypi/TaskCoach"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="libnotify"
DEPEND=">=dev-python/wxpython-2.8.9.2:2.8"
RDEPEND="${DEPEND}
	libnotify? ( dev-python/notify-python )"

S="${WORKDIR}/${MY_P}"

DOCS="CHANGES.txt"

src_install() {
	distutils_src_install

	# a bit ugly but...
	mv "${D}/usr/bin/taskcoach.py" "${D}/usr/bin/taskcoach" || die
	for file in "${D}"/usr/bin/taskcoach.py-*; do
		dir=$(dirname ${file})
		ver=$(basename ${file})
		ver=${ver#taskcoach.py-}
		mv "${file}" "${dir}/taskcoach-${ver}" || die
	done

	doicon "icons.in/${PN}.png" || die
	make_desktop_entry ${PN} "Task Coach" ${PN} Office || die
}
