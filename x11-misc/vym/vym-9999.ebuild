# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

if [[ ${PV} = *9999* ]] ; then
	EGIT_BRANCH="develop"
	EGIT_REPO_URI="https://github.com/insilmaril/${PN}.git"
	inherit git-r3
else
	COMMIT=""
	SRC_URI="https://github.com/insilmaril/${PN}/archive/develop/${COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-develop"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="View Your Mind, a mindmap tool"
HOMEPAGE="https://www.insilmaril.de/vym/"

LICENSE="GPL-2"
SLOT="0"
IUSE="dbus"

RDEPEND="
	dev-qt/qtbase:6[dbus?,gui,network,ssl,widgets,xml]
	dev-qt/qtdeclarative:6
	dev-qt/qtsvg:6
"
DEPEND="${RDEPEND}"
BDEPEND="dev-qt/qttools:6[linguist]"

PATCHES=(
	# fix install dir for doc, remove gzipped man, set VYM_DOCDIR
	"${FILESDIR}"/${PN}-2.9-docdir.patch
)

src_prepare() {
	cmake_src_prepare

	gunzip doc/vym.1.gz || die
}

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package dbus DBus1)
		-DCMAKE_INSTALL_DATAROOTDIR="share/${PN}"
	)

	cmake_src_configure
}

src_install() {
	doman doc/vym.1

	cmake_src_install
}
