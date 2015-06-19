# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/desklet-justanicon/desklet-justanicon-0.2.ebuild,v 1.9 2009/11/15 20:44:40 nixphoeni Exp $

DESKLET_NAME="JustAnIcon"

inherit gdesklets

S="${WORKDIR}/Displays/${DESKLET_NAME}"

DESCRIPTION="A configurable desktop icon"
HOMEPAGE="http://archive.gdesklets.info/"
SRC_URI="http://archive.gdesklets.info/${MY_P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
IUSE=""
KEYWORDS="~alpha ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64"
