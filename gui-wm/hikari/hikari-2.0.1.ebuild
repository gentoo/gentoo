# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="wayland compositor inspired by CWM"
HOMEPAGE="https://hikari.acmelabs.space/"
SRC_URI="https://hikari.acmelabs.space/releases/${P}.tar.gz"
KEYWORDS="~amd64 ~x86"

LICENSE="MIT"
SLOT="0"
IUSE="gamma layershell +man screencopy +X"

DEPEND="
	dev-libs/glib
	dev-libs/libinput:=
	dev-libs/libucl
	gui-libs/wlroots
	media-libs/libglvnd
	x11-libs/cairo:=[X,svg]
	x11-libs/pango:=[X]
	x11-libs/pixman
	x11-libs/libxkbcommon:=[X]
	sys-libs/pam
"

RDEPEND="
	${DEPEND}
	x11-misc/xkeyboard-config
"

BDEPEND="
	${DEPEND}
	virtual/pkgconfig
	dev-libs/wayland-protocols
	man? ( app-text/pandoc )
"

# keep this as others OS's are using this as reference
PATCHES=(
	"${FILESDIR}/${P}-gnu-make.patch"
)

src_compile() {
	emake VERSION="{PV}" \
		  WITH_POSIX_C_SOURCE=1 \
		  WITH_GAMMACONTROL=$(usex gamma 1 0) \
		  WITH_LAYERSHELL=$(usex layershell 1 0) \
		  WITH_SCREENCOPY=$(usex screencopy 1 0) \
		  WITH_XWAYLAND=$(usex X 1 0) \
		  all
	if use man; then
		emake doc
	fi
}

src_install() {
	emake PREFIX="${D}/usr" ETC_PREFIX="${D}/etc" install
	if use man; then
		emake PREFIX="${D}/usr" ETC_PREFIX="${D}/etc" install-doc
	fi
}
