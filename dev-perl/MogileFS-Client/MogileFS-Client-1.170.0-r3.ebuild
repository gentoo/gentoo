# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DORMANDO
DIST_VERSION=${PV%0.0}
inherit perl-module

DESCRIPTION="Client library for the MogileFS distributed file system"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="
	>=dev-perl/IO-stringy-2.110
	dev-perl/libwww-perl
"
BDEPEND="${RDEPEND}"
