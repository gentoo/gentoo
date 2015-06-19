# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/desklet-ftb/desklet-ftb-0.3.2.ebuild,v 1.10 2009/11/15 20:48:42 nixphoeni Exp $

DESKLET_NAME="FTB"

inherit gdesklets

S="${WORKDIR}/Displays/${DESKLET_NAME}"

DESCRIPTION="Configurable, stackable system monitors"
HOMEPAGE="http://archive.gdesklets.info/"
SRC_URI="http://archive.gdesklets.info/${MY_P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
IUSE=""
KEYWORDS="alpha ~amd64 ia64 ppc ~ppc64 ~sparc ~x86"
