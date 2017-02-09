# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 )
inherit python-single-r1

DESCRIPTION="command line selection of your X desktop environment"
HOMEPAGE="https://www.gentoo.org/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}
	x11-apps/xinit"

S="${WORKDIR}"

src_prepare() {
	cp "${FILESDIR}/${P}" "${PN}" || die
	default
}

src_install() {
	python_doscript "${WORKDIR}/${PN}"
}
