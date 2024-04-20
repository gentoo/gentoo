# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multiprocessing toolchain-funcs

DESCRIPTION="Wayland compositor inspired by CWM"
HOMEPAGE="https://hikari.acmelabs.space/"
SRC_URI="https://hikari.acmelabs.space/releases/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="X suid"

COMMON_DEPEND="
	dev-libs/glib:2
	dev-libs/libinput:=
	dev-libs/libucl
	dev-libs/wayland
	gui-libs/wlroots:0/15[X?]
	sys-libs/pam
	x11-libs/cairo
	x11-libs/libxkbcommon
	x11-libs/pango
	x11-libs/pixman"
RDEPEND="
	${COMMON_DEPEND}
	x11-misc/xkeyboard-config"
DEPEND="
	${COMMON_DEPEND}
	dev-libs/wayland-protocols"
BDEPEND="
	dev-util/wayland-scanner
	dev-build/bmake
	virtual/pkgconfig"

src_compile() {
	tc-export CC PKG_CONFIG

	local bmake=(
		bmake -j$(makeopts_jobs)
		ETC_PREFIX="${EPREFIX}"
		CFLAGS_EXTRA="${CFLAGS} ${CPPFLAGS}"
		LDFLAGS_EXTRA="${LDFLAGS}"
		VERSION=${PV}
		-DWITH_GAMMACONTROL
		-DWITH_LAYERSHELL
		-DWITH_POSIX_C_SOURCE
		-DWITH_SCREENCOPY
		-DWITH_VIRTUAL_INPUT
		$(usev X -DWITH_XWAYLAND)
	)

	# empty flags to avoid duplicates (some parts use only _EXTRA, others both)
	echo "${bmake[*]}"
	CFLAGS= LDFLAGS= "${bmake[@]}" || die
}

src_install() {
	local bmake=(
		bmake install
		DESTDIR="${D}"
		PREFIX="${EPREFIX}"/usr
		ETC_PREFIX="${EPREFIX}"
		$(usev suid -DWITH_SUID)
	)

	echo "${bmake[*]}"
	"${bmake[@]}" || die
}
