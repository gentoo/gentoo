# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A better pager for psql and mysql"
HOMEPAGE="https://github.com/okbob/${PN}"
SRC_URI="https://github.com/okbob/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="sys-libs/ncurses:*"
RDEPEND="${DEPEND}"
