# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Encode-compat/Encode-compat-0.70.0-r1.ebuild,v 1.1 2014/08/22 20:57:30 axs Exp $

EAPI=5

MODULE_AUTHOR=AUTRIJUS
MODULE_VERSION=0.07
inherit perl-module

DESCRIPTION="Encode.pm emulation layer"

SLOT="0"
KEYWORDS="amd64 ia64 ~ppc sparc x86"
IUSE=""

RDEPEND="dev-perl/Text-Iconv"
DEPEND="${RDEPEND}"

#SRC_TEST="do"
