# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

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

# Needeed in DEPEND only (not BDEPEND as need to be right location etc)
DEPEND+=" dev-libs/wayland-protocols"

BDEPEND="
	sys-devel/bmake
	virtual/pkgconfig
"

PATCHES=( "${FILESDIR}"/${PN}-2.2.1-pkgconfig.patch )

pkg_setup() {
	# We set `bmake` and we also have to remove any reference to -l in MAKEOPTS
	# as `bmake` does not support load average
	# We do this in a crude way until flag-o-matic supports MAKEOPTS
	# bug 778191
	export MAKE=bmake
	export MAKEOPTS=$(echo ${MAKEOPTS} | sed 's/-l \?[\.0-9]\+//' || die)
	tc-export CC PKG_CONFIG
}

src_compile() {
	emake \
		VERSION="${PV}" \
		CC="$(tc-getCC)" \
		CFLAGS_EXTRA="${CFLAGS}" \
		LDFLAGS_EXTRA="${LDFLAGS}" \
		-DWITH_POSIX_C_SOURCE \
		$(usex gamma -DWITH_GAMMACONTROL "") \
		$(usex layershell -DWITH_LAYERSHELL "") \
		$(usex screencopy -DWITH_SCREENCOPY "") \
		$(usex virtual-io -DWITH_VIRTUAL_INPUT "") \
		$(usex X -DWITH_XWAYLAND "") \
		all
}

src_install() {
	emake \
		DESTDIR="${D}" \
		PREFIX=/usr \
		ETC_PREFIX=/ \
		$(usex suid "" -DWITHOUT_SUID) \
		install

	doman share/man/man1/hikari.1
}
