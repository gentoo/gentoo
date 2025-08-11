# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=COSIMO
DIST_VERSION=0.50
inherit perl-module

DESCRIPTION="A WebDAV client library for Perl5"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="
	>=dev-perl/libwww-perl-5.480.0
	dev-perl/URI
	dev-perl/XML-DOM
"
BDEPEND="${RDEPEND}"
