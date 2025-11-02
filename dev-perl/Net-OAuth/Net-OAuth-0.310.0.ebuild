# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=RRWO
DIST_VERSION=0.31
inherit perl-module

DESCRIPTION="OAuth protocol support"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-perl/Class-Accessor-0.31
	>=dev-perl/Class-Data-Inheritable-0.06
	>=dev-perl/Crypt-URandom-0.370.0
	>=dev-perl/URI-5.150.0
	dev-perl/libwww-perl
"
BDEPEND="
	${RDEPEND}
	test? (
		>=dev-perl/Test-Warn-0.21
	)
"
