# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Filesys-Notify-Simple/Filesys-Notify-Simple-0.90.0.ebuild,v 1.2 2014/07/07 18:51:11 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=MIYAGAWA
MODULE_VERSION=0.09
inherit perl-module

DESCRIPTION="Simple and dumb file system watcher"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="dev-perl/Filter"
DEPEND="
	test? (
		${RDEPEND}
		dev-perl/Test-SharedFork
	)
"

SRC_TEST=do
