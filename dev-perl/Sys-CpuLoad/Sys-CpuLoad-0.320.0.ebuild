# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=RRWO
DIST_VERSION=0.32
inherit perl-module

DESCRIPTION="Module to retrieve system load averages"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-perl/File-Which
	dev-perl/IPC-Run3
"
BDEPEND="
	${RDEPEND}
	test? (
		dev-perl/Test-Deep
		dev-perl/Test-Exception
		dev-perl/Test-Warnings
	)
"
