# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/coinor-netlib/coinor-netlib-1.2.6.ebuild,v 1.2 2014/02/04 10:38:54 jlec Exp $

EAPI=5

inherit autotools-utils

MYPN=Netlib

DESCRIPTION="COIN-OR netlib models"
HOMEPAGE="https://projects.coin-or.org/svn/Data/Netlib"
SRC_URI="http://www.coin-or.org/download/source/Data/${MYPN}-${PV}.tgz"

LICENSE="EPL-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

S="${WORKDIR}/${MYPN}-${PV}"
