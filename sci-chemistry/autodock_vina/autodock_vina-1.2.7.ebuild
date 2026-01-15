# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN=AutoDock-Vina
inherit flag-o-matic toolchain-funcs

DESCRIPTION="Program for drug discovery, molecular docking and virtual screening"
HOMEPAGE="http://vina.scripps.edu/"
SRC_URI="https://github.com/ccsb-scripps/AutoDock-Vina/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}/build/linux/release"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND="dev-libs/boost:="
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${P}-gentoo.patch )

src_prepare() {
	pushd "${WORKDIR}/${MY_PN}-${PV}"  > /dev/null || die
	sed -e "s:VERSION:\"${PV}\":g" \
		-i src/main/main.cpp \
		-i src/split/split.cpp || die
	default
	popd > /dev/null || die
}

src_configure() {
	append-cxxflags -DBOOST_FILESYSTEM_VERSION=3 -DBOOST_TIMER_ENABLE_DEPRECATED -std=c++14
}

src_compile() {
	emake \
		BASE="${EPREFIX}"/usr/ \
		GPP="$(tc-getCXX)" \
		C_OPTIONS=$(usex debug '' -DNDEBUG)
}

src_install() {
	dobin vina{,_split}
}
