# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit versionator qt4-r2 eutils

DESCRIPTION="Convert an image file showing a graph or map into numbers"
HOMEPAGE="http://digitizer.sourceforge.net/"
SRC_URI="mirror://sourceforge/digitizer/digit-src-$(replace_version_separator . _).tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples"

RDEPEND="dev-qt/qt3support:4
	dev-qt/qtgui:4[gif(+)]
	sci-libs/fftw:3.0
	x11-libs/libXft"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}"

src_prepare() {
	# Some patching and using the DEBIAN_PACKAGE ifdef is necessary to make sure the
	# documentation is looked for in the proper directory
	sed -i -e "s:/usr/share/doc/engauge-digitizer-doc/html:${ROOT}/usr/share/doc/${PF}/usermanual:" \
		src/digitmain.cpp || die "sed failed"
	sed -i -e '/unix {/a DEFINES += DEBIAN_PACKAGE' \
		digitizer.pro || die "sed failed"
}

src_configure() {
	eqmake4 digitizer.pro
}

src_install() {
	dobin bin/engauge
	newicon src/img/lo32-app-digitizer.png "${PN}.png"
	make_desktop_entry engauge "Engauge Digitizer" ${PN} Graphics
	insinto /usr/share/doc/${PF}
	if use doc; then
		doins -r usermanual || die "install documentation failed"
	fi
	if use examples; then
		doins -r samples || die "install examples failed"
	fi
}
