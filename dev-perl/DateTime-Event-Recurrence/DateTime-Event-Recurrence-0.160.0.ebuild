# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=FGLOCK
MODULE_VERSION=0.16
inherit perl-module

DESCRIPTION="DateTime::Set extension for create basic recurrence sets"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-perl/DateTime
	dev-perl/DateTime-Set"
DEPEND="${RDEPEND}"

SRC_TEST=do
