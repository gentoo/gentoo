# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/perl-core/Thread-Queue/Thread-Queue-3.20.0.ebuild,v 1.2 2015/06/12 22:45:09 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=JDHEDDEN
MODULE_VERSION=3.02
inherit perl-module

DESCRIPTION="Thread-safe queues"

SLOT="0"
KEYWORDS=""
IUSE="test"

RDEPEND="dev-lang/perl[ithreads]
	>=virtual/perl-threads-shared-1.21
	virtual/perl-Scalar-List-Utils"
DEPEND="${RDEPEND}
	test? (
		virtual/perl-Thread-Semaphore
	)"

SRC_TEST=do
