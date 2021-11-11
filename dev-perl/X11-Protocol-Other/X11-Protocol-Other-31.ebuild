# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR="KRYDE"
inherit perl-module

DESCRIPTION="X11 Protocol related components not included in dev-perl/X11-Protocol"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-perl/X11-Protocol"
DEPEND="${RDEPEND}"
