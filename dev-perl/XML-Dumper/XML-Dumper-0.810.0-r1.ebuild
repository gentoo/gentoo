# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/XML-Dumper/XML-Dumper-0.810.0-r1.ebuild,v 1.1 2014/08/23 01:23:49 axs Exp $

EAPI=5

MODULE_AUTHOR=MIKEWONG
MODULE_VERSION=0.81
inherit perl-module

DESCRIPTION="Perl module for dumping Perl objects from/to XML"

SLOT="0"
KEYWORDS="amd64 hppa ia64 ppc sparc x86"
IUSE=""

RDEPEND=">=dev-perl/XML-Parser-2.16"
DEPEND="${RDEPEND}"

SRC_TEST="do"
