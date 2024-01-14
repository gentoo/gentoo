# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gap-pkg

DESCRIPTION="GAP Interface to the Atlas of Group Representations"

# How to make the test data:
#
#   gap> SetUserPreference("AtlasRep", "AtlasRepDataDirectory", "some-dir");
#   gap> SetUserPreference("AtlasRep", "AtlasRepAccessRemoteFiles", true);
#   gap> TestPackage("atlasrep"); TestPackage("orb"); ...
#
# Then tar up some-dir. This runs the test suite with downloading enabled,
# so you wind up downloading all of the data you need into some-dir (which
# has to be writable).
SRC_URI="https://www.math.rwth-aachen.de/~Thomas.Breuer/atlasrep/${P}.tar.gz
	https://www.math.rwth-aachen.de/homes/Thomas.Breuer/atlasrep/atlasrepdata.tar.gz
	https://dev.gentoo.org/~mjo/distfiles/${P}-testdata.tar.xz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-gap/io
	dev-gap/utils"

BDEPEND="test? (
	dev-gap/tomlib
)"
gap-pkg_enable_tests

PATCHES=(
	"${FILESDIR}/${P}-no-remote-access.patch"
	"${FILESDIR}/${P}-non-writable-data-dir.patch"
)

GAP_PKG_EXTRA_INSTALL=(
	atlasprm.json
	atlasprm_SHA.json
	bibl
	dataext
	datagens
	datapkg
	dataword
)

src_prepare() {
	# Move the pre-downloaded data into the empty directories where the
	# package expects them to be. The archive atlasrepdata.tar.gz
	# expands to a directory called "atlasrep".
	for s in ext gens word; do
		mv "${WORKDIR}/atlasrep/data${s}/"* "data${s}"/ || die
	done
	rm data{gens,word}/dummy || die

	default
}
