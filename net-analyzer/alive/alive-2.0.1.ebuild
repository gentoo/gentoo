# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/alive/alive-2.0.1.ebuild,v 1.1 2012/09/16 14:17:34 jer Exp $

EAPI=4

DESCRIPTION="a periodic ping program"
HOMEPAGE="http://www.gnu.org/software/alive/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~x86"
IUSE=""

DEPEND="app-arch/xz-utils"
RDEPEND="
	dev-scheme/guile
	net-misc/iputils
"
