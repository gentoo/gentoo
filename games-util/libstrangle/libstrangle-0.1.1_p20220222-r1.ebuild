# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multilib-minimal toolchain-funcs

STRANGLE_COMMIT="0273e318e3b0cc759155db8729ad74266b74cb9b"

DESCRIPTION="Frame rate limiter for OpenGL/Vulkan"
HOMEPAGE="https://gitlab.com/torkel104/libstrangle/"
SRC_URI="https://gitlab.com/torkel104/libstrangle/-/archive/${STRANGLE_COMMIT}/${P}.tar.bz2"
S="${WORKDIR}/${PN}-${STRANGLE_COMMIT}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+abi_x86_32"

RDEPEND="
	sys-apps/grep[pcre]
	elibc_glibc? (
		|| (
			>=sys-libs/glibc-2.36-r3[hash-sysv-compat]
			<sys-libs/glibc-2.36
		)
	)"
DEPEND="
	dev-util/vulkan-headers
	media-libs/libglvnd
	x11-base/xorg-proto
	x11-libs/libX11"

QA_SONAME="usr/lib.*/libstrangle.*" # intended for dlopen()

PATCHES=(
	"${FILESDIR}"/${P}-gcc13.patch
)

src_prepare() {
	default

	sed -ri '/^C(XX)?FLAGS=/s|=|+=$(CPPFLAGS) |' makefile || die

	multilib_copy_sources
}

multilib_src_compile() {
	emake CC="$(tc-getCC)" CXX="$(tc-getCXX)" LD{,XX}FLAGS="${LDFLAGS}" native
}

multilib_src_install() {
	local emakeargs=(
		DESTDIR="${D}"
		prefix="${EPREFIX}"/usr
		libdir="${EPREFIX}"/usr/$(get_libdir)
	)

	emake "${emakeargs[@]}" install-native
}

multilib_src_install_all() {
	emake DESTDIR="${D}" prefix="${EPREFIX}"/usr install-common
	einstalldocs
}
