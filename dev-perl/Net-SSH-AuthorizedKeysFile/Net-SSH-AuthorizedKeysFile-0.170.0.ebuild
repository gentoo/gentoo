# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=MSCHILLI
MODULE_VERSION=${PV:0:4}
inherit perl-module

DESCRIPTION="Read and modify ssh's authorized_keys files"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="dev-perl/Log-Log4perl"
DEPEND="${RDEPEND}"

SRC_TEST="do"
