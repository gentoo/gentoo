# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-leechcraft/lc-vgrabber/lc-vgrabber-0.6.65.ebuild,v 1.2 2014/08/10 17:59:21 slyfox Exp $

EAPI="4"

inherit leechcraft

DESCRIPTION="Allows to find, stream and save audio and video from VKontakte in LeechCraft"

SLOT="0"
KEYWORDS=" ~amd64 ~x86"
IUSE="debug"

DEPEND="~app-leechcraft/lc-core-${PV}"
RDEPEND="${DEPEND}
		virtual/leechcraft-downloader-http"

pkg_postinst() {
	einfo "For streaming to work, a suitable media player plugin is"
	einfo "needed. For example, app-leechcraft/lc-lmp will be just fine."
}
