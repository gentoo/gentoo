# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils flag-o-matic versionator

MY_P="${PN}_$(replace_all_version_separators _)"

DESCRIPTION="Program for drug discovery, molecular docking and virtual screening"
HOMEPAGE="http://vina.scripps.edu/"
SRC_URI="http://vina.scripps.edu/download/${MY_P}.tgz"

SLOT="0"
KEYWORDS="amd64 x86"
LICENSE="Apache-2.0"
IUSE="debug"

RDEPEND="dev-libs/boost[threads]"
DEPEND="${RDEPEND}"

S="${WORKDIR}"/${MY_P}/build/linux/release

src_prepare() {
	cd "${WORKDIR}"/${MY_P} || die
	epatch \
		"${FILESDIR}"/${PV}-gentoo.patch \
		"${FILESDIR}"/${P}-boost-filesystem.patch
}

src_compile() {
	local c_options

	use debug || c_options="-DNDEBUG"

	append-cxxflags -DBOOST_FILESYSTEM_VERSION=3

	emake \
		BASE="${EPREFIX}"/usr/ \
		GPP="$(tc-getCXX)" \
		C_OPTIONS="${c_options}"
}

src_install() {
	dobin vina{,_split}
}
