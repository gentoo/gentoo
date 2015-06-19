# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/CursesWidgets/CursesWidgets-1.997.0-r1.ebuild,v 1.1 2014/08/24 02:31:24 axs Exp $

EAPI=5

MODULE_VERSION=1.997
MODULE_AUTHOR=CORLISS
inherit perl-module

DESCRIPTION="Provide high level APIs for rapid user interface design on the console in Perl"
HOMEPAGE="http://www.digitalmages.com/perl/CursesWidgets/index.html ${HOMEPAGE}"
SRC_URI+=" http://www.digitalmages.com/perl/CursesWidgets/downloads/${PN}-${MODULE_VERSION}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ia64 ppc s390 sparc x86"
IUSE=""

RDEPEND=">=sys-libs/ncurses-5
	>=dev-perl/Curses-1.60.0"
DEPEND="${RDEPEND}"
