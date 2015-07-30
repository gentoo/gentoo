# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libntlm/libntlm-1.4.ebuild,v 1.8 2015/07/30 12:54:21 ago Exp $

EAPI=5
inherit autotools-utils

DESCRIPTION="Microsoft's NTLM authentication (libntlm) library"
HOMEPAGE="http://www.nongnu.org/libntlm/"
SRC_URI="http://www.nongnu.org/${PN}/releases/${P}.tar.gz"

SLOT="0"
LICENSE="LGPL-2"
KEYWORDS="alpha amd64 arm hppa ~ia64 ~mips ppc ~ppc64 sparc x86 ~x86-fbsd ~amd64-linux"
IUSE="static-libs"
