# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Device-SerialPort/Device-SerialPort-1.40.0-r1.ebuild,v 1.1 2014/08/22 19:12:32 axs Exp $

EAPI=5

MODULE_AUTHOR=COOK
MODULE_VERSION=1.04
inherit perl-module

DESCRIPTION="A Serial port Perl Module"

SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ia64 ~mips ppc sparc x86"
IUSE=""

#From the module:
# If you run 'make test', you must make sure that nothing is plugged
# into '/dev/ttyS1'!
# Doesn't sound wise to enable SRC_TEST="do" - mcummings
