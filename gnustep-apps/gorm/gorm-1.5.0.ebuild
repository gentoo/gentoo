# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic gnustep-2

DESCRIPTION="A clone of the NeXTstep Interface Builder application for GNUstep"
HOMEPAGE="https://www.gnustep.org/experience/Gorm.html"
SRC_URI="https://github.com/gnustep/apps-${PN}/archive/refs/tags/${P//./_}.tar.gz"

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

src_configure() {
	# bug #946603
	if has_version gnustep-base/gnustep-make[libobjc2]; then
		append-ldflags $(no-as-needed)
	fi

	gnustep-base_src_configure
}
