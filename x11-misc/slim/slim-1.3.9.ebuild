# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake pam readme.gentoo-r1 systemd

DESCRIPTION="Simple Login Manager resurrected"
HOMEPAGE="https://slim-fork.sourceforge.io/"
SRC_URI="mirror://sourceforge/project/${PN}-fork/${P}.tar.gz"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"

LICENSE="GPL-2"
SLOT="0"
IUSE="branding pam"

RDEPEND="media-libs/libjpeg-turbo:=
	media-libs/libpng:0=
	x11-apps/sessreg
	x11-libs/libX11
	x11-libs/libXft
	x11-libs/libXmu
	x11-libs/libXpm
	x11-libs/libXrandr
	pam? (
		sys-libs/pam
		x11-libs/libXext
	)"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"
BDEPEND="virtual/pkgconfig"
PDEPEND="branding? ( >=x11-themes/slim-themes-1.2.3a-r3 )"

PATCHES=(
	# Our Gentoo-specific config changes
	"${FILESDIR}"/${P}-config.diff
	"${FILESDIR}"/${P}-greeter-session.diff
)

DISABLE_AUTOFORMATTING=1
DOC_CONTENTS="
The configuration file is located at /etc/slim.conf.

If you wish ${PN} to start automatically, set DISPLAYMANAGER=\"${PN}\"
in /etc/conf.d/display-manager and run

	# rc-update add display-manager default.

See also https://wiki.gentoo.org/wiki/SLiM
"

src_prepare() {
	cmake_src_prepare

	if use branding; then
		sed -i -e '/current_theme/s/default/slim-gentoo-simple/' slim.conf || die
	fi
}

src_configure() {
	local mycmakeargs=(
		-DUSE_PAM=$(usex pam)
		-DUSE_CONSOLEKIT=OFF
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	if use pam ; then
		pamd_mimic system-local-login slim auth account session
		pamd_mimic system-local-login slimlock auth
	fi

	systemd_dounit slim.service

	insinto /usr/share/slim
	newins "${FILESDIR}/Xsession-r3" Xsession

	insinto /etc/logrotate.d
	newins "${FILESDIR}/slim.logrotate" slim

	dodoc xinitrc.sample ChangeLog README TODO THEMES
	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog

	if ! use pam; then
		elog "You have merged ${PN} without USE=\"pam\", this will cause ${PN} to fall back to"
		elog "the console when restarting your window manager. If this is not desired, then"
		elog "please remerge ${PN} with USE=\"pam\""
		elog
	fi
}
