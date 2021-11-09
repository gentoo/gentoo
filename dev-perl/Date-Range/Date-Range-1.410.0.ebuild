# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=TMTM
DIST_VERSION=1.41
inherit perl-module

DESCRIPTION="work with a range of dates"

SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	>=dev-perl/Date-Simple-0.30.0
"
BDEPEND="${RDEPEND}
"
