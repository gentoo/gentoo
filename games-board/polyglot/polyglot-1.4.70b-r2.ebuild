# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Protocol adapter to run UCI chess engines under xboard"
HOMEPAGE="http://hardy.uhasselt.be/Toga/"
# not entirely clear what the "b" in the version stands for
SRC_URI="http://hardy.uhasselt.be/Toga/${PN}-release/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DOCS="AUTHORS ChangeLog TODO" # README* installed by build system
