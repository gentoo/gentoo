# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Proc-Daemon/Proc-Daemon-0.140.0-r1.ebuild,v 1.3 2013/12/17 17:28:36 zlogene Exp $

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
