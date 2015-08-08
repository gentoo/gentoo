# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )
inherit python-single-r1 eutils

DESCRIPTION="A KSplashX engine (KDE4) Splash Screen Creator"
HOMEPAGE="http://ksplasher.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}x${PV/_}.tar.gz"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="${PYTHON_DEPS}
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/PyQt4[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

S=${WORKDIR}/${PN}x

src_prepare() {
	epatch "${FILESDIR}/${PN}-pillow.patch"
	# ksplasherx is a bash script which calls 'python foo'. We fix it here.
	sed -i -e 's:python:/usr/bin/env python2:g' ksplasherx || die
}

src_install() {
	dobin ksplasherx || die
	insinto /usr/share/ksplasherx
	doins -r src || die
	python_fix_shebang "${ED}/usr/share/ksplasherx/src/"
	doicon ksicon.png
	make_desktop_entry ${PN}x KSplasherX ksicon "Qt;KDE;Graphics"
	dodoc README
}
