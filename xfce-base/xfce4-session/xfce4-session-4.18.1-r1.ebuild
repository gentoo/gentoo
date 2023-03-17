# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg-utils

DESCRIPTION="A session manager for the Xfce desktop environment"
HOMEPAGE="
	https://docs.xfce.org/xfce/xfce4-session/start
	https://gitlab.xfce.org/xfce/xfce4-session
"
SRC_URI="
	https://archive.xfce.org/src/xfce/${PN}/${PV%.*}/${P}.tar.bz2
	https://gitlab.xfce.org/xfce/xfce4-session/-/commit/911f5b8101dec6a6d28f7601768588a2f0fd4aaf.patch
		-> ${P}-mem1.patch
	https://gitlab.xfce.org/xfce/xfce4-session/-/commit/cff23d0fadd502f7db9230f9ebbc02c00853f825.patch
		-> ${P}-mem2.patch
"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ~ppc ppc64 ~riscv ~sparc x86 ~amd64-linux ~x86-linux"
IUSE="nls policykit +xscreensaver"

DEPEND="
	>=dev-libs/glib-2.66.0
	>=x11-libs/gtk+-3.24.0:3
	x11-libs/libSM
	x11-libs/libwnck:3
	x11-libs/libX11
	>=xfce-base/libxfce4util-4.15.2:=
	>=xfce-base/libxfce4ui-4.18.2:=
	>=xfce-base/xfconf-4.12:=
	policykit? ( >=sys-auth/polkit-0.102 )
"
RDEPEND="
	${DEPEND}
	x11-apps/iceauth
	x11-apps/xrdb
	nls? ( x11-misc/xdg-user-dirs )
	xscreensaver? (
		|| (
			xfce-extra/xfce4-screensaver
			>=x11-misc/xscreensaver-5.26
			x11-misc/light-locker
		)
	)
"
BDEPEND="
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig
"

PATCHES=(
	"${DISTDIR}/${P}-mem1.patch"
	"${DISTDIR}/${P}-mem2.patch"
)

src_configure() {
	local myconf=(
		$(use_enable policykit polkit)
		--with-xsession-prefix="${EPREFIX}"/usr
		ICEAUTH="${EPREFIX}"/usr/bin/iceauth
	)

	econf "${myconf[@]}"
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die

	exeinto /etc/X11/Sessions
	newexe - Xfce4 <<-EOF
		startxfce4
	EOF
	dosym Xfce4 /etc/X11/Sessions/Xfce
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
