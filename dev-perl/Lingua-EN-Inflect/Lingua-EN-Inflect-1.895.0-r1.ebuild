# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Lingua-EN-Inflect/Lingua-EN-Inflect-1.895.0-r1.ebuild,v 1.2 2015/06/13 22:11:02 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=DCONWAY
MODULE_VERSION=1.895
inherit perl-module

DESCRIPTION='Perl module to pluralize English words'

SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE=""

DEPEND="
	dev-perl/Module-Build
"

SRC_TEST="do"
