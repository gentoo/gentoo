# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools toolchain-funcs virtualx

DESCRIPTION="Lean FLTK based web browser"
HOMEPAGE="https://dillo-browser.github.io/"

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/dillo-browser/dillo.git"
else
	SRC_URI="
		https://github.com/dillo-browser/dillo/releases/download/v${PV}/${P}.tar.bz2
		test? ( https://deps.gentoo.zip/www-client/${P}-html-tests.tar.xz )
	"
	KEYWORDS="~amd64"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="debug doc +gif +jpeg mbedtls +png +ssl +openssl +xembed"
REQUIRED_USE="
	ssl? ( || ( openssl mbedtls ) )
"

RDEPEND="
	>=x11-libs/fltk-1.3:1
	sys-libs/zlib
	x11-libs/libX11
	jpeg? ( media-libs/libjpeg-turbo:= )
	png? ( >=media-libs/libpng-1.2:= )
	ssl? (
		mbedtls? ( net-libs/mbedtls:= )
		openssl? ( dev-libs/openssl:= )
	)
	test? (
		media-gfx/imagemagick
		x11-apps/xwd
		x11-apps/xwininfo
	)

"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	doc? ( app-text/doxygen )
"

DOCS="AUTHORS ChangeLog README NEWS doc/*.txt doc/README"

PATCHES=(
	"${FILESDIR}"/${P}-remove-floatref.patch
)

src_prepare() {
	default
	if use test; then
		# https://github.com/dillo-browser/dillo/pull/176
		# Upstream forgot to package tests for 3.1.0, I've done it
		# so we'll just move them into place for this release.
		rm -r "${S}"/test/html || die "Failed to remove broken test dir"
		mv "${WORKDIR}"/html test/ || die "Failed to add good tests"
	fi
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable debug rtfl)
		$(use_enable gif)
		$(use_enable jpeg)
		$(use_enable mbedtls)
		$(use_enable openssl)
		$(use_enable png)
		$(use_enable ssl tls)
		$(use_enable xembed)
		--enable-ipv6
	)

	use test && myeconfargs+=( --enable-html-tests=yes )

	econf "${myeconfargs[@]}"
}

src_compile() {
	emake AR="$(tc-getAR)"

	if use doc; then
		doxygen Doxyfile || die
	fi
}

src_test() {
	# The test suite consistently fails with -jN in portage
	virtx emake -j1 check
}

src_install() {
	default

	use doc && dodoc -r html
}
