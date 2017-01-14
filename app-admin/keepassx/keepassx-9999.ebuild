# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils gnome2-utils vcs-snapshot xdg

DESCRIPTION="Qt password manager compatible with its Win32 and Pocket PC versions"
HOMEPAGE="http://www.keepassx.org/"

if [[ "${PV}" == "9999" ]] ; then
	inherit git-r3
	SRC_URI=""
	EGIT_REPO_URI="git://github.com/keepassx/keepassx.git"
else
	KEYWORDS="~amd64 ~arm ~ppc ~x86 ~amd64-linux ~x86-linux"
	SRC_URI="https://www.keepassx.org/releases/${PV}/${P}.tar.gz"
fi

LICENSE="|| ( GPL-2 GPL-3 ) BSD GPL-2 LGPL-2.1 LGPL-3+ CC0-1.0 public-domain || ( LGPL-2.1 GPL-3 )"
SLOT="0"
IUSE="test"

DEPEND="
	dev-libs/libgcrypt:0=
	dev-qt/linguist-tools:5
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qttest:5
	dev-qt/qtwidgets:5
	sys-libs/zlib
	x11-libs/libX11
	x11-libs/libXtst
"
RDEPEND="${DEPEND}"

DOCS=(CHANGELOG)

src_prepare() {
	xdg_src_prepare
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DWITH_TESTS="$(usex test)"
	)
	cmake-utils_src_configure
}

pkg_preinst() {
	gnome2_icon_savelist
	xdg_pkg_preinst
}
pkg_postinst() {
	gnome2_icon_cache_update
	xdg_pkg_postinst
}

pkg_postrm() {
	gnome2_icon_cache_update
	xdg_pkg_postrm
}
