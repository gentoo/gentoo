# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-beep/vdr-beep-0.1.2.ebuild,v 1.2 2012/06/30 17:51:45 hd_brummy Exp $

EAPI="4"

inherit vdr-plugin-2

DESCRIPTION="VDR plugin: Use the PC speaker to signalize some events (shutdown, cut done etc.)"
HOMEPAGE="http://www.deltab.de/content/view/25/62/"
SRC_URI="http://www.deltab.de/component/option,com_docman/task,doc_download/gid,104/Itemid,62/ -> ${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND=">=media-video/vdr-1.6.0"
DEPEND="${RDEPEND}"
