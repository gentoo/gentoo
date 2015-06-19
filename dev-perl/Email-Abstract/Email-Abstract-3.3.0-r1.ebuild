# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Email-Abstract/Email-Abstract-3.3.0-r1.ebuild,v 1.2 2015/06/13 18:50:03 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=RJBS
MODULE_VERSION=3.003
inherit perl-module

DESCRIPTION="unified interface to mail representations"

SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE=""

RDEPEND="dev-perl/MRO-Compat
	>=dev-perl/Email-Simple-1.91
	>=dev-perl/Module-Pluggable-1.5
	virtual/perl-Scalar-List-Utils"
DEPEND="${RDEPEND}"

SRC_TEST="do"
