# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vdr-plugin-2

DESCRIPTION="VDR plugin: Use the PC speaker to signalize some events (shutdown, cut done ...)"
HOMEPAGE="http://www.deltab.de/content/view/25/62/"
SRC_URI="http://www.deltab.de/component/option,com_docman/task,doc_download/gid,104/Itemid,62/ -> ${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=media-video/vdr-1.6.0"
DEPEND="${RDEPEND}"
