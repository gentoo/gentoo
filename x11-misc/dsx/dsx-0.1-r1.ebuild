# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit python-single-r1

DESCRIPTION="Command line selection of your X desktop environment"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc x86"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND=""
RDEPEND="
	${PYTHON_DEPS}
	x11-apps/xinit"

S="${WORKDIR}"

src_install() {
	python_newscript "${FILESDIR}/${P}" "${PN}"
}
