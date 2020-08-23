# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

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
	>=gui-libs/wlroots-0.11.0
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
	virtual/pkgconfig
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
		  WITH_SUID=$(usex suid 1 0) \
		  WITH_VIRTUAL_INPUT=$(usex virtual-io 1 0) \
		  WITH_XWAYLAND=$(usex X 1 0) \
		  all
}

src_install() {
	emake PREFIX="${D}/usr" ETC_PREFIX="${D}" prefix="${SYSROOT}/usr" install install-doc
	doman share/man/man1/hikari.1
}
