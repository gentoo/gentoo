# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_AUTORECONF="true"
AUTOTOOLS_IN_SOURCE_BUILD="true"
inherit autotools-utils

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/zevv/duc.git"
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://github.com/zevv/${PN}/releases/download/${PV}/${P}.tar.gz"
fi

DESCRIPTION="A library and suite of tools for inspecting disk usage"
HOMEPAGE="https://github.com/zevv/duc"

LICENSE="GPL-2"
SLOT="0"
IUSE="cairo gui -leveldb ncurses -sqlite +tokyocabinet X"

REQUIRED_USE="
	^^ ( tokyocabinet leveldb sqlite )
	X? ( cairo gui )
"

DEPEND="
	cairo? ( x11-libs/cairo x11-libs/pango )
	gui? (
		X? (
			x11-libs/cairo[X]
			x11-libs/libX11
			x11-libs/pango[X]
		)
		!X? ( virtual/opengl )
	)
	leveldb? ( dev-libs/leveldb )
	ncurses? ( sys-libs/ncurses:= )
	sqlite? ( dev-db/sqlite:3 )
	tokyocabinet? ( dev-db/tokyocabinet )
"
RDEPEND="${DEPEND}"

src_unpack() {
	if [[ "${PV}" == "9999" ]]; then
		git-r3_src_unpack
	else
		unpack ${A}
	fi
}

src_prepare() {
	sed -i -e "/ldconfig/d" -e "/install-exec-hook/d" Makefile.am || die

	autotools-utils_src_prepare
}

src_configure() {
	local myconf=(
		--disable-static
		$(use_with ncurses ui)
	)

	if use tokyocabinet; then
		myconf+=( --with-db-backend=tokyocabinet )
	elif	use leveldb; then
		myconf+=( --with-db-backend=leveldb )
	else
		myconf+=( --with-db-backend=sqlite3 )
	fi

	# Necessary logic for cairo
	if use gui && use X; then
		# X backend GUI
		myconf+=( --enable-x11 --disable-opengl --enable-cairo )
	elif use gui; then
		# OpenGL backend GUI
		myconf+=( --disable-x11 --enable-opengl $(use_enable cairo) )
	else
		# No GUI
		myconf+=( $(use_enable cairo) )
	fi

	autotools-utils_src_configure
}
