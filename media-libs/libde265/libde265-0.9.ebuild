# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libde265/libde265-0.9.ebuild,v 1.2 2015/01/29 17:35:51 mgorny Exp $

EAPI=5

AUTOTOOLS_IN_SOURCE_BUILD=1
AUTOTOOLS_AUTORECONF=1
inherit autotools-multilib

DESCRIPTION="Open h.265 video codec implementation"
HOMEPAGE="https://github.com/strukturag/libde265"
SRC_URI="https://github.com/strukturag/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug qt4 qt5 static-libs cpu_flags_x86_sse tools"

DEPEND="
	qt4? ( dev-qt/qtgui:4 dev-qt/qtcore:4 )
	qt5? ( dev-qt/qtgui:5 dev-qt/qtcore:5 dev-qt/qtwidgets:5 )
	media-libs/libsdl
	virtual/ffmpeg
"
RDEPEND="${DEPEND}"

REQUIRED_USE="tools? ( || ( qt4 qt5 ) )"

src_configure() {
	local myeconfargs=(
		$(use_enable cpu_flags_x86_sse sse)
		$(use_enable static-libs static)
		$(use_enable debug log-info)
		$(use_enable debug log-debug)
		$(use_enable debug log-trace)
		$(use_enable tools dec265)
		$(use_enable tools sherlock265)
		--disable-silent-rules
		--enable-log-error
	)
	autotools-multilib_src_configure "${myeconfargs[@]}"
}
