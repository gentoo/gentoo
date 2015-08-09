# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=DETI
MODULE_SECTION=Proc
MODULE_VERSION=0.14
inherit perl-module

DESCRIPTION="Perl Proc-Daemon -  Run Perl program as a daemon process"

SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE="test"

DEPEND="test? ( dev-perl/Proc-ProcessTable )"

PATCHES=( "${FILESDIR}"/debian_pid.patch )

SRC_TEST="do"
