# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multiprocessing toolchain-funcs

DESCRIPTION="Wayland compositor inspired by CWM"
HOMEPAGE="https://hikari.acmelabs.space/"
SRC_URI="https://hikari.acmelabs.space/releases/${P}.tar.gz"
KEYWORDS="~amd64 ~x86"

LICENSE="MIT"
SLOT="0"
IUSE="gamma layershell screencopy suid virtual-io +X"

DEPEND="
	dev-libs/libinput:=
	dev-libs/libucl
	>=gui-libs/wlroots-0.11.0[X?]
	media-libs/libglvnd
	x11-libs/cairo[X?,svg]
	x11-libs/libxkbcommon[X?]
	x11-libs/pango[X?]
	x11-libs/pixman
	sys-libs/pam
"

RDEPEND="
	${DEPEND}
	x11-misc/xkeyboard-config
"

BDEPEND="
	dev-libs/wayland-protocols
	sys-devel/bmake
	virtual/pkgconfig
"

PATCHES=( "${FILESDIR}"/${PN}-2.2.1-pkgconfig.patch )

pkg_setup() {
	export MAKE=bmake
	tc-export CC PKG_CONFIG
}

src_compile() {
	${MAKE} -j$(makeopts_jobs) VERSION="{PV}" \
		CC="$(tc-getCC)" \
		CFLAGS_EXTRA="${CFLAGS}" \
		LDFLAGS_EXTRA="${LDFLAGS}" \
		-DWITH_POSIX_C_SOURCE \
		$(usex gamma -DWITH_GAMMACONTROL "") \
		$(usex layershell -DWITH_LAYERSHELL "") \
		$(usex screencopy -DWITH_SCREENCOPY "") \
		$(usex virtual-io -DWITH_VIRTUAL_INPUT "") \
		$(usex X -DWITH_XWAYLAND "") \
		all || die
}

src_install() {
	${MAKE} DESTDIR="${D}" PREFIX=/usr ETC_PREFIX=/ \
	$(usex suid "" -DWITHOUT_SUID) \
	install || die
	doman share/man/man1/hikari.1
}
