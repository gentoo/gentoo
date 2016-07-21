# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=JRENNIE
MODULE_VERSION=1.49
inherit perl-module

DESCRIPTION="Direct perl interface to WordNet database"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-dicts/wordnet"
RDEPEND="${DEPEND}"

src_configure() {
	export WNHOME=/usr
	perl-module_src_configure
}
