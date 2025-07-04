# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DORMANDO
DIST_VERSION=${PV%0.0}
inherit perl-module

DESCRIPTION="Server for the MogileFS distributed file system"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="dev-perl/libwww-perl
	>=dev-perl/MogileFS-Client-1.160.0"
DEPEND="${RDEPEND}"
