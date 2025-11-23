# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

MY_P=${PN}${PV//./_}

DESCRIPTION="sff to bmp converter"
HOMEPAGE="https://sfftools.sourceforge.io/"
SRC_URI="https://downloads.sourceforge.net/sfftools/${MY_P}_src.zip"
S="${WORKDIR}/${MY_P}"

LICENSE="HPND MIT"
SLOT="0"
KEYWORDS="amd64 ~hppa ppc x86"

RDEPEND="
	dev-libs/boost:=
	media-libs/libjpeg-turbo:=
	media-libs/tiff:=
"
DEPEND="${RDEPEND}"
BDEPEND="app-arch/unzip"

PATCHES=(
	"${FILESDIR}"/${PN}-3.1.1-gcc44-and-boost-1_37.patch
	"${FILESDIR}"/${PN}-3.1.2-boost_fs3.patch
	"${FILESDIR}"/${PN}-3.1.2-Wformat.patch
	"${FILESDIR}"/${PN}-3.1.2-boost-1.85.patch
)

src_prepare() {
	default
	eautoreconf
}

src_install() {
	default
	dodoc doc/{changes,credits,readme}
}
