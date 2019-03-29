# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="OpenGFX data files for OpenTTD"
HOMEPAGE="http://bundles.openttdcoop.org/opengfx/"
SRC_URI="http://bundles.openttdcoop.org/opengfx/releases/${PV}/${P}-source.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""
RESTRICT="test" # nml version affects the checksums that the test uses (bug #451444)

DEPEND=">=games-util/nml-0.4.0
	games-util/grfcodec"
RDEPEND=""

S="${WORKDIR}/${P}-source"

PATCHES=(
	"${FILESDIR}/${PN}-0.5.5-Makefile.patch"
)

src_compile() {
	emake GIMP=""  help  # print out the env to make bug reports better
	emake GIMP="" _V="" bundle_tar
}

src_install() {
	insinto "/usr/share/games/openttd/data/"
	doins *.grf opengfx.obg
	dodoc docs/{changelog.txt,readme.txt}
}
