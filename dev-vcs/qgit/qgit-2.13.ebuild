# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION="Qt-based GUI for Git repositories"
HOMEPAGE="https://github.com/tibirna/qgit"
SRC_URI="https://github.com/tibirna/qgit/archive/${P}.tar.gz"
S="${WORKDIR}/${PN}-${P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"

DEPEND="
	dev-qt/qt5compat:6[gui]
	dev-qt/qtbase:6[gui,widgets]
"
RDEPEND="${DEPEND}
	dev-vcs/git
"

DOCS=( README.adoc )

src_configure() {
	local mycmakeargs=(
		-DQT_PACKAGE=Qt6
	)
	cmake_src_configure
}
