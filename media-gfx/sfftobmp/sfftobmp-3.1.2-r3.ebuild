# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

MY_P=${PN}${PV//./_}

DESCRIPTION="sff to bmp converter"
HOMEPAGE="https://sfftools.sourceforge.io/"
SRC_URI="mirror://sourceforge/sfftools/${MY_P}_src.zip"
S="${WORKDIR}/${MY_P}"

LICENSE="HPND MIT"
SLOT="0"
KEYWORDS="amd64 ~hppa ppc x86"

RDEPEND="
	dev-libs/boost:=
	media-libs/libjpeg-turbo:=
	media-libs/tiff:="
DEPEND="${RDEPEND}"
BDEPEND="app-arch/unzip"

PATCHES=(
	"${FILESDIR}"/${PN}-3.1.1-gcc44-and-boost-1_37.patch
	"${FILESDIR}"/${PN}-3.1.2-boost_fs3.patch
	"${FILESDIR}"/${PN}-3.1.2-Wformat.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	append-cppflags -DBOOST_FILESYSTEM_VERSION=3
	default
}

src_install() {
	default
	dodoc doc/{changes,credits,readme}
}
