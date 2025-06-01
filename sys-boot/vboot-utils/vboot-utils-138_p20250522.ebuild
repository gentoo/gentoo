# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Chrome OS verified boot tools"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/vboot_reference/ https://dev.chromium.org/chromium-os/chromiumos-design-docs/verified-boot"
# Can't use gitiles directly until https://github.com/google/gitiles/issues/84 is fixed.
#SRC_URI="https://chromium.googlesource.com/chromiumos/platform/vboot_reference/+archive/refs/heads/release-R138-16295.B.tar.gz -> ${P}.tar.gz"
SRC_URI="https://dev.gentoo.org/~zmedico/dist/${P}.tar.xz"
S=${WORKDIR}
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~x86"
IUSE="+libzip"
RESTRICT=test

RDEPEND="
	dev-libs/openssl:0=
	sys-apps/util-linux:=
	elibc_musl? ( sys-libs/fts-standalone:= )
	libzip? ( dev-libs/libzip:= )
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/vboot-utils-138-musl-fts.patch
)

src_prepare() {
	default

	# Bug #687008
	if ! use libzip; then
		sed -e 's|^\(LIBZIP_VERSION :=\).*|\1|' -i Makefile || die
	fi
}

_emake() {

	local arch=$(tc-arch)
	emake \
		V=1 \
		ARCH=${arch} \
		LIBDIR="$(get_libdir)" \
		DEBUG_FLAGS= \
		WERROR= \
		USE_FLASHROM=0 \
		$(usex elibc_musl HAVE_MUSL=1 "") \
		"$@"
}

src_compile() {
	tc-export CC AR CXX PKG_CONFIG
	_emake FUZZ_TEST_BINS= TEST_BINS= all
}

src_install() {
	_emake DESTDIR="${ED}" install install_dev

	insinto /usr/share/vboot/devkeys
	doins tests/devkeys/*

	dodoc README
}
