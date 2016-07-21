# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=SNOWHARE
MODULE_VERSION=0.84
inherit perl-module

DESCRIPTION="Porter's stemming algorithm for 'generic' English"

SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

RDEPEND="dev-perl/Snowball-Norwegian
	dev-perl/Snowball-Swedish
	dev-perl/Lingua-Stem-Snowball-Da
	dev-perl/Lingua-Stem-Fr
	dev-perl/Lingua-Stem-It
	dev-perl/Lingua-Stem-Ru
	dev-perl/Lingua-PT-Stemmer
	dev-perl/Text-German"
DEPEND="dev-perl/Module-Build
	${RDEPEND}"

SRC_TEST="do"
