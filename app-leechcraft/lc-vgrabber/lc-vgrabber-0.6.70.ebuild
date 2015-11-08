# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit leechcraft

DESCRIPTION="Allows to find, stream and save audio and video from VKontakte in LeechCraft"

SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="debug"

DEPEND="~app-leechcraft/lc-core-${PV}"
RDEPEND="${DEPEND}
		virtual/leechcraft-downloader-http"

pkg_postinst() {
	einfo "For streaming to work, a suitable media player plugin is"
	einfo "needed. For example, app-leechcraft/lc-lmp will be just fine."
}
