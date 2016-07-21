# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

EGIT_REPO_URI="https://github.com/mgorny/eclean-kernel2.git"
inherit autotools git-r3

DESCRIPTION="Clean up old and stale kernel files"
HOMEPAGE="https://github.com/mgorny/eclean-kernel2"
SRC_URI=""

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE=""

src_prepare() {
	default
	eautoreconf
}
