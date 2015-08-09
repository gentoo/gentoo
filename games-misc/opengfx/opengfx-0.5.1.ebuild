# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils games

DESCRIPTION="OpenGFX data files for OpenTTD"
HOMEPAGE="http://bundles.openttdcoop.org/opengfx/"
SRC_URI="http://bundles.openttdcoop.org/opengfx/releases/${PV}/${P}-source.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc x86"
IUSE=""
RESTRICT="test" # nml version affects the checksums that the test uses (bug #451444)

DEPEND=">=games-util/nml-0.3.0
	games-util/grfcodec"
RDEPEND=""

S=${WORKDIR}/${P}-source

src_prepare() {
	# ensure that we will not use gimp to regenerate the pngs
	# causes sandbox violations and not worth the effort anyway
	sed -i -e '/^GFX_SCRIPT_LIST_FILES/s/^/#/' Makefile.config || die
	# work with later versions of unix2dos from app-text/dos2unix
	sed -i -e '/^UNIX2DOS_FLAGS/s/null/null >&2/' Makefile || die
}

src_compile() {
	emake help  # print out the env to make bug reports better
	_V= emake bundle_tar
}

src_install() {
	insinto "${GAMES_DATADIR}/openttd/data/"
	doins *.grf opengfx.obg
	dodoc docs/{changelog.txt,readme.txt}
	prepgamesdirs
}
