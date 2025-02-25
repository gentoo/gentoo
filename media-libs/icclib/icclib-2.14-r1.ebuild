# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

MY_P="${PN}_V${PV}"

DESCRIPTION="Library for reading and writing ICC color profile files"
HOMEPAGE="http://freshmeat.sourceforge.net/projects/icclib"
SRC_URI="http://www.argyllcms.com/${MY_P}.zip"
S="${WORKDIR}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="app-arch/unzip"

PATCHES=(
	"${FILESDIR}/${P}-fno-common.patch"
	"${FILESDIR}/${P}-c23.patch"
)

src_prepare() {
	default

	cp "${FILESDIR}"/meson.build . || die "Failed to move corrected build system"
}

src_test() {
	"${BUILD_DIR}"/iccdump 2>&1 | tee log
	if ! grep -q "Dump an ICC file in human readable form" log ; then
	die "Executable couldn't be started"
	fi
}

src_install() {
	meson_install

	doheader icc*.h
	dodoc Readme.txt todo.txt log.txt
}
