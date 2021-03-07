# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=RHANDOM
DIST_VERSION=0.11
inherit perl-module

DESCRIPTION="Allow complex data structures to be encoded using flat URIs"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-solaris"

RDEPEND="
	dev-perl/CGI
"
BDEPEND="${RDEPEND}"
