# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit qmake-utils versionator

MY_PV=$(replace_version_separator 2 '')

DESCRIPTION="Tool for extracting data points from graphs"
HOMEPAGE="http://star.physics.yale.edu/~ullrich/xyscanDistributionPage/"
SRC_URI="http://star.physics.yale.edu/~ullrich/${PN}DistributionPage/${MY_PV}/${PN}-${MY_PV}-src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="l10n_fr"

RDEPEND="dev-qt/qtcore:4
	dev-qt/qtgui:4"
DEPEND="$RDEPEND"

S="${WORKDIR}/${PN}"

src_prepare() {
	default
	sed -i \
		-e "s:qApp->applicationDirPath() + \"/../docs\":\"${EPREFIX}/usr/share/doc/${PF}/html\":" \
		xyscanWindow.cpp || die "Failed to fix docs path"
}

src_configure() {
	eqmake4
}

src_install() {
	dobin xyscan
	HTML_DOCS=( docs/en/. )
	einstalldocs
	use l10n_fr && dodoc -r docs/fr
	newicon images/xyscanIcon.png xyscan.png
	make_desktop_entry xyscan "xyscan data point extractor"
}
