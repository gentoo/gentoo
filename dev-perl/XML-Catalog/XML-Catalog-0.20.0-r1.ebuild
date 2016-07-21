# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=EBOHLMAN
MODULE_VERSION=0.02
inherit perl-module

DESCRIPTION="Resolve public identifiers and remap system identifiers"

SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc sparc x86"
IUSE=""

RDEPEND=">=dev-perl/XML-Parser-2.29
	>=dev-perl/libwww-perl-5.48"
DEPEND="${RDEPEND}"
