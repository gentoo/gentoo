# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="'top' for PostgreSQL"
HOMEPAGE="https://pg_top.gitlab.io/"
SRC_URI="https://pg_top.gitlab.io/source/${P}.tar.xz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-db/postgresql:=
	dev-libs/libbsd
	sys-libs/ncurses:=
	virtual/libelf:="
DEPEND="${RDEPEND}"
BDEPEND="dev-python/docutils"

DOCS=( HISTORY.rst README.rst TODO Y2K )
