# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=RCLAMP
DIST_VERSION=1.02
inherit perl-module

DESCRIPTION="Expand filenames"

SLOT="0"
KEYWORDS="~alpha amd64 ~ppc ~ppc64 ~sparc x86"

BDEPEND="
	dev-perl/Module-Build
"
