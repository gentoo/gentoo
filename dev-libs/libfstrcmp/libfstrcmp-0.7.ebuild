# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Make fuzzy comparisons of strings and byte arrays"
HOMEPAGE="http://fstrcmp.sourceforge.net/"

LICENSE="GPL-3+"
IUSE="test"
SLOT="0"

SRC_URI="http://fstrcmp.sourceforge.net/fstrcmp-0.7.D001.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/fstrcmp-0.7.D001"
KEYWORDS="~amd64 ~x86"
