# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/XML-Encoding/XML-Encoding-2.80.0-r1.ebuild,v 1.1 2014/08/23 01:24:41 axs Exp $

EAPI=5

MODULE_AUTHOR=SHAY
MODULE_VERSION=2.08
inherit perl-module

DESCRIPTION="Perl Module that parses encoding map XML files"

SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc sparc x86"
IUSE=""

RDEPEND="dev-perl/XML-Parser"
DEPEND="${RDEPEND}"

SRC_TEST=do
