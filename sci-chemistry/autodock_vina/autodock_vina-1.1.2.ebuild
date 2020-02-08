# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic

MY_P="${PN}_$(ver_rs 1- _)"

DESCRIPTION="Program for drug discovery, molecular docking and virtual screening"
HOMEPAGE="http://vina.scripps.edu/"
SRC_URI="http://vina.scripps.edu/download/${MY_P}.tgz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug"

RDEPEND="dev-libs/boost:=[threads]"
DEPEND="${RDEPEND}"

S="${WORKDIR}"/${MY_P}/build/linux/release

PATCHES=(
	"${FILESDIR}"/${PV}-gentoo.patch
	"${FILESDIR}"/${P}-boost-filesystem.patch
	"${FILESDIR}"/${P}-missing-debug-decl.patch
)

src_prepare() {
	cd "${WORKDIR}"/${MY_P} || die
	default
}

src_configure() {
	use debug || c_options="-DNDEBUG"
	append-cxxflags -DBOOST_FILESYSTEM_VERSION=3
}

src_compile() {
	emake \
		BASE="${EPREFIX}"/usr/ \
		GPP="$(tc-getCXX)" \
		C_OPTIONS="${c_options}"
}

src_install() {
	dobin vina{,_split}
}
