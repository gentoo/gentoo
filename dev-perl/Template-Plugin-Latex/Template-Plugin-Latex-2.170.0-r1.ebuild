# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Template-Plugin-Latex/Template-Plugin-Latex-2.170.0-r1.ebuild,v 1.2 2015/02/22 11:23:33 zlogene Exp $

EAPI=5

MODULE_AUTHOR=ANDREWF
MODULE_VERSION=2.17
MY_PN=Template-Latex
MY_P=${MY_PN}-${MODULE_VERSION}
S=${WORKDIR}/${MY_P}
inherit perl-module eutils

DESCRIPTION="Template::Latex - Latex support for the Template Toolkit"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~x86-fbsd"
IUSE="test"

RDEPEND=">=dev-perl/Template-Toolkit-2.15
	virtual/perl-File-Spec
	virtual/latex-base"
DEPEND="${RDEPEND}
	test? ( virtual/perl-Test-Harness )"

SRC_TEST="do"
PATCHES=( "${FILESDIR}/Makefile.patch" )
