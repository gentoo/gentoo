# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=SAMTREGAR
MODULE_VERSION=0.07
inherit perl-module

DESCRIPTION="HTML::Template extension adding expression support"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=dev-perl/HTML-Template-2.8
	dev-perl/Parse-RecDescent"
DEPEND="${RDEPEND}"

SRC_TEST="do"
