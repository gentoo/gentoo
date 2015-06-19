# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Class-Virtual/Class-Virtual-0.60.0-r1.ebuild,v 1.1 2014/08/22 20:52:07 axs Exp $

EAPI=5

MODULE_AUTHOR=MSCHWERN
MODULE_VERSION=0.06
inherit perl-module

DESCRIPTION="Base class for virtual base classes"

SLOT="0"
KEYWORDS="amd64 ia64 ~ppc sparc x86 ~x86-solaris"
IUSE=""

RDEPEND="dev-perl/Class-Data-Inheritable
	dev-perl/Carp-Assert
	dev-perl/Class-ISA"
DEPEND="${RDEPEND}"

SRC_TEST="do"
