# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/IPC-Run/IPC-Run-0.920.0-r1.ebuild,v 1.6 2015/01/24 10:08:45 zlogene Exp $

EAPI=5

MODULE_AUTHOR=TODDR
MODULE_VERSION=0.92
inherit perl-module

DESCRIPTION="system() and background procs w/ piping, redirs, ptys"

SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86 ~x86-linux"
IUSE="test"

RDEPEND=">=dev-perl/IO-Tty-1.08"
DEPEND="${RDEPEND}
	test? ( dev-perl/Test-Pod
		dev-perl/Test-Pod-Coverage )"

SRC_TEST=do
