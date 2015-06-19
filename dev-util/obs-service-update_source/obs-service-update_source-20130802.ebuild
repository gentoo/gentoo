# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/obs-service-update_source/obs-service-update_source-20130802.ebuild,v 1.1 2013/11/02 10:05:31 scarabeus Exp $

EAPI=5

inherit obs-service

IUSE=""
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND="${DEPEND}
	net-misc/wget
	sys-apps/diffutils
"
