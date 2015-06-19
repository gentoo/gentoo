# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/ImageSize/ImageSize-3.232.0-r1.ebuild,v 1.1 2014/08/22 20:59:08 axs Exp $

EAPI=5

MY_PN=Image-Size
MODULE_AUTHOR=RJRAY
MODULE_VERSION=3.232
inherit perl-module

DESCRIPTION="A library to extract height/width from images"

LICENSE="|| ( Artistic-2 LGPL-2.1 )"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE=""

RDEPEND="
	virtual/perl-IO-Compress
	virtual/perl-File-Spec
"
DEPEND="${RDEPEND}"

SRC_TEST="do"
mydoc="ToDo"
