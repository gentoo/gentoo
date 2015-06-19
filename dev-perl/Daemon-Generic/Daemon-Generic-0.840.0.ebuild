# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Daemon-Generic/Daemon-Generic-0.840.0.ebuild,v 1.2 2014/07/29 21:37:14 zlogene Exp $

EAPI=5

MODULE_AUTHOR=MUIR
MODULE_SECTION=modules
MODULE_VERSION=0.84
inherit perl-module

DESCRIPTION="Framework to provide start/stop/reload for a daemon"

SLOT="0"
KEYWORDS="alpha amd64 ia64 ppc ppc64 sparc x86"
IUSE="test"

RDEPEND="
	dev-perl/File-Flock
	dev-perl/File-Slurp
	dev-perl/AnyEvent
"
DEPEND="${RDEPEND}
	test? (
		dev-perl/Eval-LineNumbers
	)
"

SRC_TEST="do"
