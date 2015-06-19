# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/perl-core/I18N-LangTags/I18N-LangTags-0.35-r1.ebuild,v 1.2 2014/11/08 15:36:10 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=SBURKE
MY_PN=I18N-LangTags
MY_P=${MY_PN}-${PV}
S=${WORKDIR}/${MY_P}
inherit perl-module

DESCRIPTION="RFC3066 language tag handling for Perl"
SRC_URI+=" http://dev.gentoo.org/~tove/files/${MY_P}-Detect-1.04.patch"

SLOT="0"
KEYWORDS=""
IUSE=""

SRC_TEST="do"
PATCHES=( "${DISTDIR}"/${MY_P}-Detect-1.04.patch )
