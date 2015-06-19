# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-rcu/vdr-rcu-2.2.0.ebuild,v 1.1 2015/02/20 09:36:45 hd_brummy Exp $

EAPI=5

inherit vdr-plugin-2

DESCRIPTION="VDR plugin: Remote Control Unit consists mainly of an infrared receiver, controlled by a PIC 16C84"
HOMEPAGE="http://www.tvdr.de/remote.htm"
SRC_URI="mirror://gentoo/${P}.tar.gz
		http://dev.gentoo.org/~hd_brummy/distfiles/${P}.tar.gz"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

DEPEND=">=media-video/vdr-2.2.0"
