# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit cmake-utils

MY_P=${P}-Source

DESCRIPTION="The Chewing IMEngine for IBus Framework"
HOMEPAGE="https://code.google.com/p/ibus/"
SRC_URI="https://ibus.googlecode.com/files/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls"

RDEPEND="x11-libs/libXtst
	>=app-i18n/ibus-1.3
	>=dev-libs/libchewing-0.3.3
	x11-libs/gtk+:2
	dev-util/gob:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${MY_P}

CMAKE_IN_SOURCE_BUILD=1

DOCS="AUTHORS ChangeLog README RELEASE-NOTES.txt USER-GUIDE"

src_configure() {
	local mycmakeargs=(
		-DPRJ_DOC_DIR=/usr/share/doc/${PF}
		)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_make all translations
}
