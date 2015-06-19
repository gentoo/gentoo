# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/perl-core/Locale-Maketext/Locale-Maketext-1.230.0-r1.ebuild,v 1.2 2015/06/07 14:22:39 dilfridge Exp $

EAPI=5

MY_PN=Locale-Maketext
MODULE_AUTHOR=TODDR
MODULE_VERSION=1.23
inherit perl-module

DESCRIPTION="Localization framework for Perl programs"

SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND=">=virtual/perl-I18N-LangTags-0.31"
DEPEND="${RDEPEND}"

SRC_TEST="do"
