# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=KING
MODULE_VERSION=0.13
inherit perl-module

DESCRIPTION="Copy and paste with any OS"

SLOT="0"
KEYWORDS="amd64 arm ppc ppc64 x86"
IUSE=""

# See bug 521890.
PATCHES=(
	"${FILESDIR}"/"${P}"-insecure-tempfile.patch
)

RDEPEND="x11-misc/xclip"
