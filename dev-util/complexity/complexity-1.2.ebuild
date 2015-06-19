# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/complexity/complexity-1.2.ebuild,v 1.1 2014/12/21 11:41:25 jer Exp $

EAPI=5

DESCRIPTION="a tool designed for analyzing the complexity of C program functions"
HOMEPAGE="http://www.gnu.org/software/complexity/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~x86"

RDEPEND=">=sys-devel/autogen-5.11.7"
DEPEND="
	${RDEPEND}
	sys-devel/libtool
"

DOCS=( AUTHORS ChangeLog NEWS )
