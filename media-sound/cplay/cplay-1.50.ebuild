# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit python-single-r1

DESCRIPTION="A Curses front-end for various audio players"
HOMEPAGE="https://github.com/hukka/cplay/"
SRC_URI="https://github.com/hukka/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE="mp3 vorbis"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	vorbis? ( media-sound/vorbis-tools )
	mp3? ( || ( media-sound/mpg123
		media-sound/mpg321
		media-sound/madplay
		media-sound/splay ) )"
DEPEND="${RDEPEND}
	sys-devel/gettext"

src_prepare() {
	default
	sed -i -e 's:make:$(MAKE):' Makefile || die
	sed -i -e "s:/usr/local:${EPREFIX}/usr:" cplay || die
}

src_install() {
	emake PREFIX="${ED%/}/usr" recursive-install
	einstalldocs

	python_fix_shebang cplay
	dobin cplay
	doman cplay.1
}
