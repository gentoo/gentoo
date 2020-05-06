# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=CFAERBER
MODULE_VERSION=0.11
inherit perl-module

DESCRIPTION="Parse and format SQLite dates and times"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~x86-solaris"
IUSE=""

RDEPEND=">=dev-perl/DateTime-0.51
	>=dev-perl/DateTime-Format-Builder-0.79.01"
DEPEND="${RDEPEND}"

SRC_TEST=do
