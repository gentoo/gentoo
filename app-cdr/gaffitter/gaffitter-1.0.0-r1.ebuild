# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

SV="0.1.0"
SCRIPTS="scripts-${SV}"

DESCRIPTION="Genetic Algorithm File Fitter"
HOMEPAGE="https://gaffitter.sourceforge.net/"
SRC_URI="
	https://downloads.sourceforge.net/${PN}/${P}.tar.gz
	scripts? ( https://downloads.sourceforge.net/${PN}/scripts/${SV}/${SCRIPTS}.tar.bz2 )"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="scripts"

src_prepare() {
	default
	if use scripts; then
		sed -i -re "s:--data((cd)|(dvd)):--data:" "${WORKDIR}"/${PN}/${SCRIPTS}/gaff-k3b || die
	fi
	cmake_src_prepare
}

src_configure(){
	local mycmakeargs=(
		-DCMAKE_SKIP_RPATH=ON
	)
	cmake_src_configure
}

src_install() {
	newbin "${BUILD_DIR}"/fit ${PN}
	dolib.so "${BUILD_DIR}"/src/optimizers/liboptimizers.so
	dolib.so "${BUILD_DIR}"/src/util/libutil.so

	einstalldocs

	if use scripts; then
		dobin "${WORKDIR}"/${PN}/${SCRIPTS}/gaff-{brasero,iso,k3b}
		dobin "${WORKDIR}"/${PN}/${SCRIPTS}/nautilus/nautilus-gaff-k3b-{cd{,-split},dvd{,-split}}
	fi
}
