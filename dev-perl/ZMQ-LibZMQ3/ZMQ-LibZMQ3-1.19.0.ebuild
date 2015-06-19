# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/ZMQ-LibZMQ3/ZMQ-LibZMQ3-1.19.0.ebuild,v 1.3 2015/04/03 19:28:28 zlogene Exp $

EAPI=5

MODULE_AUTHOR=DMAKI
MODULE_VERSION=1.19
inherit perl-module

DESCRIPTION="A libzmq 3.x wrapper for Perl"

SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~x86"
IUSE="test"

RDEPEND="
	=net-libs/zeromq-3*
	dev-perl/ZMQ-Constants
	virtual/perl-XSLoader
"
DEPEND="${RDEPEND}
	 dev-perl/Task-Weaken
	virtual/perl-ExtUtils-MakeMaker
	virtual/pkgconfig
	test? (
		dev-perl/Test-Requires
		dev-perl/Test-Fatal
		dev-perl/Test-TCP
		virtual/perl-Test-Simple
	)
"

SRC_TEST=do
