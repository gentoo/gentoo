# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR="JMGDOC"
DIST_VERSION="2.125"

inherit perl-module

DESCRIPTION="The Perl Open OpenDocument Connector"

SLOT="0"
KEYWORDS="~amd64"

RDEPEND=">=dev-perl/XML-Twig-3.520.0
	>=dev-perl/Archive-Zip-1.590.0"

BDEPEND="${RDEPEND}"
