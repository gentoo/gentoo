# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils

DESCRIPTION="A DDR clone for linux written in Python"
HOMEPAGE="http://www.icculus.org/pyddr/"
SRC_URI="http://www.icculus.org/pyddr/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/pygame
	media-libs/libvorbis
	media-libs/sdl-mixer"
RDEPEND="${DEPEND}"
PDEPEND="games-arcade/pydance-songs"

src_prepare() {
	default
	sed -i -e "s:1\.0\.1:1.0.2:" \
		pydance.py constants.py docs/man/pydance.6 || die
	sed -i -e 's:/usr/share/games/pydance/:/usr/share/pydance/:g' pydance.posix.cfg || die
}

src_install() {
	local dir=/usr/share/${PN}

	insinto "${dir}"
	doins *.py
	cp -R CREDITS {sound,images,utils,themes} "${D}${dir}/" || die

	insinto /etc/
	newins pydance.posix.cfg pydance.cfg

	make_wrapper pydance "python2 ./pydance.py" "${dir}"

	dodoc BUGS CREDITS ChangeLog HACKING README TODO
	HTML_DOCS="docs/manual.html docs/images" einstalldocs
	doman docs/man/*
}
