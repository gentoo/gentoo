# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-pda/libopensync-plugin-gnokii/libopensync-plugin-gnokii-0.36.ebuild,v 1.2 2013/04/17 14:20:03 creffett Exp $

EAPI="2"

inherit cmake-utils

DESCRIPTION="OpenSync Gnokii Plugin"
HOMEPAGE="http://www.opensync.org/"
SRC_URI="http://www.opensync.org/download/releases/${PV}/${P}.tar.bz2"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

DEPEND="=app-pda/libopensync-${PV}*
	>=app-mobilephone/gnokii-0.6.14"
RDEPEND="${DEPEND}"
