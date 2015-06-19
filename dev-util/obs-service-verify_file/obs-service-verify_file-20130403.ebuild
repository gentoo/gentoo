# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/obs-service-verify_file/obs-service-verify_file-20130403.ebuild,v 1.1 2013/11/02 09:38:00 scarabeus Exp $

EAPI=5

inherit obs-service

LICENSE="MIT"
IUSE=""
KEYWORDS="amd64 x86"

DEPEND=""
RDEPEND="${DEPEND}
	net-misc/wget
"
