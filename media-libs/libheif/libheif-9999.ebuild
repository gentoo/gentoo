# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools xdg multilib-minimal

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/strukturag/libheif.git"
	inherit git-r3
else
	SRC_URI="https://github.com/strukturag/libheif/releases/download/v${PV}/${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"
fi

DESCRIPTION="ISO/IEC 23008-12:2017 HEIF file format decoder and encoder"
HOMEPAGE="https://github.com/strukturag/libheif"

LICENSE="GPL-3"
SLOT="0/1.12"
IUSE="+aom gdk-pixbuf go rav1e test +threads x265"
REQUIRED_USE="test? ( go )"
RESTRICT="!test? ( test )"

BDEPEND="test? ( dev-lang/go )"
DEPEND="
	media-libs/dav1d:=[${MULTILIB_USEDEP}]
	media-libs/libde265:=[${MULTILIB_USEDEP}]
	media-libs/libpng:0=[${MULTILIB_USEDEP}]
	sys-libs/zlib:=[${MULTILIB_USEDEP}]
	media-libs/libjpeg-turbo:0=[${MULTILIB_USEDEP}]
	aom? ( >=media-libs/libaom-2.0.0:=[${MULTILIB_USEDEP}] )
	gdk-pixbuf? ( x11-libs/gdk-pixbuf[${MULTILIB_USEDEP}] )
	go? ( dev-lang/go )
	rav1e? ( media-video/rav1e:= )
	x265? ( media-libs/x265:=[${MULTILIB_USEDEP}] )"
RDEPEND="${DEPEND}"

src_prepare() {
	default

	sed -i -e 's:-Werror::' configure.ac || die

	eautoreconf

	# prevent "stat heif-test.go: no such file or directory"
	multilib_copy_sources
}

multilib_src_configure() {
	export GO111MODULE=auto
	local econf_args=(
		--enable-libde265
		--disable-static
		$(multilib_is_native_abi && use go || echo --disable-go)
		$(use_enable aom)
		$(use_enable gdk-pixbuf)
		$(use_enable rav1e)
		$(use_enable threads multithreading)
		$(use_enable x265)
	)
	ECONF_SOURCE="${S}" econf "${econf_args[@]}"
}

multilib_src_test() {
	default
	emake -C go test
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -name '*.la' -delete || die
}
