# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnustep-apps/gwnet/gwnet-0.1.0.8.2.ebuild,v 1.4 2007/11/16 15:30:52 beandog Exp $

inherit gnustep-2

S=${WORKDIR}/GWorkspace-${PV/0.1.}/${PN/gwn/GWN}

DESCRIPTION="A GNUstep network filesystem file browser"
HOMEPAGE="http://www.gnustep.it/enrico/gworkspace/"
SRC_URI="mirror://gentoo/gworkspace-${PV/0.1.}.tar.gz"

KEYWORDS="amd64 ppc x86"
LICENSE="GPL-2"
SLOT="0"

DEPEND="gnustep-libs/smbkit"
RDEPEND="${DEPEND}"
