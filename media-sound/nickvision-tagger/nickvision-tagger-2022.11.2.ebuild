# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

REAL_PN=NickvisionTagger
REAL_P=${REAL_PN}-${PV}

inherit meson xdg

DESCRIPTION="An easy-to-use music tag (metadata) editor"
HOMEPAGE="https://github.com/nlogozzo/NickvisionTagger/"
SRC_URI="https://github.com/nlogozzo/${REAL_PN}/archive/${PV}.tar.gz
	-> ${P}.tar.gz"
S="${WORKDIR}"/${REAL_P}

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	dev-cpp/curlpp:=
	dev-libs/jsoncpp:=
	gui-libs/gtk:4
	gui-libs/libadwaita:=
	media-libs/taglib:=
"
RDEPEND="
	${DEPEND}
	media-libs/chromaprint[tools]
"

PATCHES=( "${FILESDIR}"/${P}-meson-install.patch )

DOCS=( README.md )
