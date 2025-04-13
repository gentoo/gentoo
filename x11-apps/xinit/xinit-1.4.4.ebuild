# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit eapi9-ver xorg-3

DESCRIPTION="X Window System initializer"

LICENSE="${LICENSE} GPL-2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~arm-linux ~x86-linux"
IUSE="twm"

RDEPEND="
	x11-apps/xauth
	x11-libs/libX11
"
DEPEND="${RDEPEND}"
PDEPEND="x11-apps/xrdb
	twm? (
		x11-apps/xclock
		x11-apps/xsm
		x11-terms/xterm
		x11-wm/twm
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-1.4.4-gentoo-customizations.patch"
	"${FILESDIR}/${PN}-1.4.4-startx-current-vt.patch"
	"${FILESDIR}/${PN}-1.4.4-move-serverauthfile-into-tmp.patch"
)

XORG_CONFIGURE_OPTIONS=(
	--with-xinitdir="${EPREFIX}"/etc/X11/xinit
)

src_install() {
	xorg-3_src_install

	exeinto /etc/X11
	doexe "${FILESDIR}"/chooser.sh
	exeinto /etc/X11/Sessions
	doexe "${FILESDIR}"/Xsession
	exeinto /etc/X11/xinit
	newexe "${FILESDIR}"/xserverrc.2 xserverrc
	exeinto /etc/X11/xinit/xinitrc.d/
	doexe "${FILESDIR}"/00-xhost

	insinto /usr/share/xsessions
	doins "${FILESDIR}"/Xsession.desktop
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		ewarn "If you use startx to start X instead of a login manager like gdm/kdm,"
		ewarn "you can set the XSESSION variable to anything in /etc/X11/Sessions/ or"
		ewarn "any executable. When you run startx, it will run this as the login session."
		ewarn "You can set this in a file in /etc/env.d/ for the entire system,"
		ewarn "or set it per-user in ~/.bash_profile (or similar for other shells)."
		ewarn "Here's an example of setting it for the whole system:"
		ewarn "    echo XSESSION=\"Gnome\" > /etc/env.d/90xsession"
		ewarn "    env-update && source /etc/profile"
	elif ver_replacing "-lt" "1.4.1"; then
		ewarn "Starting with ${CATEGORY}/${PN}-1.4.1 serverauth files are no longer kept in the"
		ewarn "home directory but rather are created in \$TMPDIR (typically /tmp).  The change"
		ewarn "is transparent for most of users, however those that use runtime temporary"
		ewarn "directories cleaning tools, like app-admin/tmpreaper, may need to adjust them"
		ewarn "not to remove the 'serverauth.*' files."
	fi
}
