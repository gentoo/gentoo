# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 )

inherit desktop distutils-r1

MY_PN="TaskCoach"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Simple personal tasks and todo lists manager"
HOMEPAGE="https://www.taskcoach.org https://pypi.org/project/TaskCoach/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"
LICENSE="GPL-3+"

SLOT="0"
KEYWORDS="~amd64 x86"

# Task Coach can also optionally use igraph to draw task dependency graphs
# since 1.4.4, but that is not packaged in Gentoo at this time.

DEPEND="
	dev-python/wxpython:3.0[${PYTHON_USEDEP}]
	|| (
		>=dev-python/twisted-16.0.0[${PYTHON_USEDEP}]
		>=dev-python/twisted-core-10.0[${PYTHON_USEDEP}]
	)
"
RDEPEND="${DEPEND}
	x11-libs/libXScrnSaver
"

S="${WORKDIR}/${MY_P}"

DOCS=( CHANGES.txt README.txt )
PATCHES=( "${FILESDIR}/${PN}-1.4.3-version-check.patch" )

python_install_all() {
	distutils-r1_python_install_all

	doicon "icons.in/${PN}.png"
	make_desktop_entry ${PN}.py "Task Coach" ${PN} Office
}
