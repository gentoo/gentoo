# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MLEHMANN
inherit perl-module

DESCRIPTION="Pass a file descriptor to another process, using a unix domain socket"

SLOT="0"
KEYWORDS="~amd64 ~hppa ~x86"

DEPEND="
	dev-perl/Canary-Stability
"
RDEPEND="${DEPEND}"
