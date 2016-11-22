# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit python-single-r1

DESCRIPTION="A GUI for cdlabelgen that generates CD labels"
HOMEPAGE="http://gtkcdlabel.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

DEPEND="${PYTHON_DEPS}
	>=app-cdr/cdlabelgen-4
	dev-python/pygtk[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

S="${WORKDIR}"

src_prepare() {
	default
	python_fix_shebang .
}

src_install() {
	dobin "usr/bin/${PN}.py"
	insinto /usr/share
	doins -r usr/share/{applications,"${PN}",pixmaps}
	dodoc usr/share/doc/"${PN}"/{AUTHORS,README}
}
