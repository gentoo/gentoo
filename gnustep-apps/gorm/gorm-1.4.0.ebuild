# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit gnustep-2

DESCRIPTION="A clone of the NeXTstep Interface Builder application for GNUstep"
HOMEPAGE="https://gnustep.github.io/experience/Gorm.html"
SRC_URI="ftp://ftp.gnustep.org/pub/gnustep/dev-apps/${P}.tar.gz"

S=${WORKDIR}/apps-${PN}-${PN}-${PV//./_}
LICENSE="GPL-3+ LGPL-2.1+"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

DEPEND=">=gnustep-base/gnustep-gui-0.31.0"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i -e "/DOCUMENT_NAME =.*/a \Gorm_DOC_INSTALL_DIR=Developer/Gorm" \
		-e "/DOCUMENT_TEXT_NAME =.*/a \ANNOUNCE_DOC_INSTALL_DIR=Developer/Gorm/ReleaseNotes" \
		-e "/DOCUMENT_TEXT_NAME =.*/a \README_DOC_INSTALL_DIR=Developer/Gorm/ReleaseNotes" \
		-e "/DOCUMENT_TEXT_NAME =.*/a \NEWS_DOC_INSTALL_DIR=Developer/Gorm/ReleaseNotes" \
		-e "/DOCUMENT_TEXT_NAME =.*/a \INSTALL_DOC_INSTALL_DIR=Developer/Gorm/ReleaseNotes" \
		Documentation/GNUmakefile

	default
}
