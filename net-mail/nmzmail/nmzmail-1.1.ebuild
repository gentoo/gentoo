# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Fast mail searching for mutt using namazu"
HOMEPAGE="https://www.ecademix.com/JohannesHofmann/nmzmail.html"
SRC_URI="https://www.ecademix.com/JohannesHofmann/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

DEPEND="sys-libs/readline"
RDEPEND="${DEPEND}
	>=app-text/namazu-2"
