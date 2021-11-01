# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=SAMTREGAR
DIST_VERSION=0.07
inherit perl-module

DESCRIPTION="HTML::Template extension adding expression support"

SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	>=dev-perl/HTML-Template-2.800.0
	dev-perl/Parse-RecDescent
"
BDEPEND="${RDEPEND}
"
