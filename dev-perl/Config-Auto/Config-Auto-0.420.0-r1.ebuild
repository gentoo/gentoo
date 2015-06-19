# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Config-Auto/Config-Auto-0.420.0-r1.ebuild,v 1.1 2014/08/26 17:19:48 axs Exp $

EAPI=5

MODULE_AUTHOR="BINGOS"
MODULE_VERSION=0.42
inherit perl-module

DESCRIPTION="Magical config file parser"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-perl/Config-IniFiles
	dev-perl/IO-String
	virtual/perl-Text-ParseWords
	virtual/perl-File-Spec
	dev-perl/yaml
"
DEPEND="${RDEPEND}"

SRC_TEST="do"
