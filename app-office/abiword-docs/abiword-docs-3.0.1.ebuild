# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/abiword-docs/abiword-docs-3.0.1.ebuild,v 1.3 2015/03/15 13:15:32 pacho Exp $

EAPI=5
GCONF_DEBUG="no"

inherit gnome2

DESCRIPTION="Fully featured yet light and fast cross platform word processor documentation"
HOMEPAGE="http://www.abisource.com/"
SRC_URI="http://www.abisource.com/downloads/abiword/${PV}/source/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=app-office/abiword-${PV}"
DEPEND="${RDEPEND}"
