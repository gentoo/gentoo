# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils fixheadtails multilib

DESCRIPTION="Erlang bindings for the SDL library"
HOMEPAGE="http://esdl.sourceforge.net/"
SRC_URI="mirror://sourceforge/esdl/${P}.src.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ppc ppc64 x86"
IUSE="image truetype"

RDEPEND="
	>=dev-lang/erlang-14[wxwidgets]
	media-libs/libsdl[opengl]
	image? ( media-libs/sdl-image )
	truetype? ( media-libs/sdl-ttf )
	virtual/opengl
"
DEPEND="
	${RDEPEND}
	dev-util/rebar
"

src_compile() {
	rebar compile || die
}

src_install() {
	ERLANG_DIR="/usr/$(get_libdir)/erlang/lib"
	ESDL_DIR="${ERLANG_DIR}/${P}"

	find -name 'Makefile*' -exec rm -f '{}' \;

	insinto ${ESDL_DIR}
	doins -r ebin c_src include priv src
}
