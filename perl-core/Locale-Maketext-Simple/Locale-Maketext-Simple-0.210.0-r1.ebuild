# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=JESSE
MODULE_VERSION=0.21
inherit perl-module

DESCRIPTION="Locale::Maketext::Simple - Simple interface to Locale::Maketext::Lexicon"

SLOT="0"
KEYWORDS="alpha amd64 ia64 ~ppc sparc x86 ~amd64-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE=""

#RDEPEND=""
#DEPEND="test? ( dev-perl/locale-maketext-lexicon )"

SRC_TEST="do"
