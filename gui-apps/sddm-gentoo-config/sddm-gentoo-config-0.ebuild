# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Gentoo defaults for SDDM (Simple Desktop Display Manager)"
HOMEPAGE="https://wiki.gentoo.org/wiki/SDDM"
SRC_URI=""
S=${WORKDIR}

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="kwin weston"
REQUIRED_USE="?? ( kwin weston )"

RDEPEND="
	!<x11-misc/sddm-0.21.0_p20250818
	kwin? ( kde-plasma/kwin:6 )
	weston? ( dev-libs/weston )
	!kwin? ( !weston? ( x11-base/xorg-server ) )
"

GEN2CONF=01gentoo.conf

src_prepare() {
	touch "${T}"/${GEN2CONF} || die

	_displayserver() {
		if use kwin || use weston; then
			echo "wayland"
		else
			echo "x11"
		fi
	}

	cat >> "${T}"/${GEN2CONF} <<- _EOF_ || die
		[General]
		# Remove qtvirtualkeyboard as InputMethod default
		InputMethod=

		# Which display server should be used
		DisplayServer=$(_displayserver)
	_EOF_

	if use kwin; then
		cat >> "${T}"/${GEN2CONF} <<- _EOF_ || die

			GreeterEnvironment=QT_WAYLAND_SHELL_INTEGRATION=layer-shell

			[Wayland]
			CompositorCommand=kwin_wayland --drm --no-lockscreen --no-global-shortcuts --locale1
		_EOF_
	fi

	default
}

src_install() {
	insinto /etc/sddm.conf.d/
	doins "${T}"/${GEN2CONF}
}
