# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake
if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/oyranos-cms/Synnefo.git"
	inherit git-r3
else
	SRC_URI="https://github.com/oyranos-cms/Synnefo/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/Synnefo-${PV}"
fi

DESCRIPTION="Qt front end for the Oyranos Color Management System"
HOMEPAGE="https://github.com/oyranos-cms/Synnefo"
LICENSE="BSD-2"
SLOT="0"
IUSE=""

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	>=media-libs/oyranos-0.9.6
"
RDEPEND="${DEPEND}
	x11-misc/xcalib
"

DOCS=( AUTHORS.md README.md )
