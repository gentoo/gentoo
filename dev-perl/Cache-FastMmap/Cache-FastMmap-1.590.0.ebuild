# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ROBM
DIST_VERSION=1.59
inherit perl-module

DESCRIPTION="Uses an mmaped file to act as a shared memory interprocess cache"

SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="
	test? ( dev-perl/Test-Deep )
"
