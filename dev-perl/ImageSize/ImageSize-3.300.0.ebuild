# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/ImageSize/ImageSize-3.300.0.ebuild,v 1.1 2015/07/04 11:20:13 dilfridge Exp $

EAPI=5

MY_PN=Image-Size
MODULE_AUTHOR=RJRAY
MODULE_VERSION=3.300
inherit perl-module

DESCRIPTION="A library to extract height/width from images"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="test"

RDEPEND="
	virtual/perl-IO-Compress
	>=virtual/perl-File-Spec-0.800.0
"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.420.0
	test? (
		virtual/perl-Test-Simple
	)
"

SRC_TEST="do parallel"
mydoc="ToDo"
