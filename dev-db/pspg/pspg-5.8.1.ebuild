# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A better pager for CLI database clients, and can substitute psql"
HOMEPAGE="https://github.com/okbob/pspg"
SRC_URI="https://github.com/okbob/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="postgres"
RESTRICT="test"

RDEPEND="
sys-libs/ncurses:=
sys-libs/readline:=
postgres? ( dev-db/postgresql:= )
"
DEPEND="${RDEPEND}"

src_configure() {
	econf $(use_with postgres postgresql)
}
