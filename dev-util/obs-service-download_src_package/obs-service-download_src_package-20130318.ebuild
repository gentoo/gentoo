# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/obs-service-download_src_package/obs-service-download_src_package-20130318.ebuild,v 1.2 2013/03/18 10:50:37 miska Exp $

EAPI=5

inherit obs-service

IUSE=""
KEYWORDS="amd64 x86"

DEPEND=""
RDEPEND="${DEPEND}
	net-misc/wget
"
