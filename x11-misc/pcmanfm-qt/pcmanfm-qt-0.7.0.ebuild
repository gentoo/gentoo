# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/pcmanfm-qt/pcmanfm-qt-0.7.0.ebuild,v 1.2 2014/05/29 07:49:55 mrueg Exp $

EAPI=5

inherit cmake-utils multilib readme.gentoo

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://git.lxde.org/git/lxde/${PN}"
else
	SRC_URI="http://lxqt.org/downloads/${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm ~x86"
	S="${WORKDIR}"
fi

DESCRIPTION="Fast lightweight tabbed filemanager (Qt port)"
HOMEPAGE="http://pcmanfm.sourceforge.net/"

LICENSE="GPL-2 LGPL-2.1+"
SLOT="0"

CDEPEND=">=dev-libs/glib-2.18:2
	dev-qt/qtcore:4
	dev-qt/qtdbus:4
	dev-qt/qtgui:4
	>=lxde-base/menu-cache-0.4.1
	>=x11-libs/libfm-1.2.0"
RDEPEND="${CDEPEND}
	virtual/eject
	virtual/freedesktop-icon-theme"
DEPEND="${CDEPEND}
	>=dev-util/intltool-0.40
	sys-devel/gettext
	virtual/pkgconfig"

src_prepare() {
	# fix multilib
	sed -i -e "/LIBRARY\ DESTINATION/s:lib:$(get_libdir):" \
		libfm-qt/CMakeLists.txt || die
	cmake-utils_src_prepare
}

src_install() {
	cmake-utils_src_install
	DOC_CONTENTS="Be sure to set an icon theme in Edit > Preferences > User Interface"
	readme.gentoo_src_install
}
