# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3

SCM=""
if [ "${PV%9999}" != "${PV}" ] ; then
	SCM=git-2
	EGIT_BOOTSTRAP=""
	EGIT_REPO_URI="git://git.videolan.org/${PN}.git"
fi

inherit autotools multilib ${SCM}

DESCRIPTION="Mozilla plugin based on VLC"
HOMEPAGE="http://www.videolan.org/"

LICENSE="LGPL-2.1"
SLOT="0"

if [ "${PV%9999}" = "${PV}" ] ; then
	KEYWORDS="amd64 ~ppc64 x86"
	SRC_URI="http://download.videolan.org/pub/videolan/vlc/${PV}/${P}.tar.xz"
	DEPEND="app-arch/xz-utils"
else
	KEYWORDS=""
	SRC_URI=""
fi
IUSE="gtk"

RDEPEND=">=media-video/vlc-1.1
	x11-libs/libX11
	!gtk? ( x11-libs/libXpm x11-libs/libSM x11-libs/libICE )
	gtk? ( x11-libs/gtk+:2 )
	!<media-video/vlc-1.2[nsplugin]"
DEPEND="${RDEPEND}
	${DEPEND}
	virtual/pkgconfig
	>=net-misc/npapi-sdk-0.27"

src_prepare() {
	if [ "${PV%9999}" != "${PV}" ] ; then
		eautoreconf
	fi
	cp "${FILESDIR}/xembed.h" "${S}/npapi/" || die
}

src_configure() {
	econf \
		$(use_with gtk)
}

src_install() {
	emake DESTDIR="${D}" npvlcdir="/usr/$(get_libdir)/nsbrowser/plugins" install || die
	find "${D}" -name '*.la' -delete
	dodoc NEWS AUTHORS ChangeLog || die
}
