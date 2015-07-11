# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Lirc-Client/Lirc-Client-2.20.0.ebuild,v 1.1 2015/07/11 20:27:31 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=MGRIMES
MODULE_VERSION=2.02
inherit perl-module

DESCRIPTION="A client library for the Linux Infrared Remote Control (LIRC)"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
	dev-perl/File-Path-Expand
	>=dev-perl/Moo-1.0.0
"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.360.0
	virtual/perl-File-Spec
	virtual/perl-IO
	test? ( virtual/perl-Test-Simple )
"

SRC_TEST="do parallel"
