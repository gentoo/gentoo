# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Fast mail searching for mutt using namazu"
HOMEPAGE="https://flpsed.org/nmzmail.html"
SRC_URI="https://flpsed.org/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

DEPEND="sys-libs/readline:="
RDEPEND="${DEPEND}
	>=app-text/namazu-2"
