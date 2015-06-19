# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/HTTP-Negotiate/HTTP-Negotiate-6.0.1-r1.ebuild,v 1.7 2015/04/04 23:58:12 vapier Exp $

EAPI=5

MODULE_AUTHOR=GAAS
MODULE_VERSION=${PV/0./0}
inherit perl-module

DESCRIPTION="HTTP content negotiation"

SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~ppc-aix ~amd64-fbsd ~x86-fbsd ~x86-interix ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND="
	!<dev-perl/libwww-perl-6
	>=dev-perl/HTTP-Message-6.0.0
"
DEPEND="${RDEPEND}"

SRC_TEST=online
