# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=PMAKHOLM
DIST_VERSION=1.05
inherit perl-module

DESCRIPTION="Modification of UTF-7 encoding for IMAP"

SLOT="0"
KEYWORDS="amd64 ppc x86"

BDEPEND="
	test? (
		dev-perl/Test-NoWarnings
	)
"
