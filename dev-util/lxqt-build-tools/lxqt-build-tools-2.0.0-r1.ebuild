# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="LXQt Build Tools"
HOMEPAGE="https://lxqt-project.org/"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/lxqt/${PN}.git"
else
	SRC_URI="https://github.com/lxqt/${PN}/releases/download/${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm64 ~loong ~riscv"
fi

LICENSE="BSD"
SLOT="0"

DEPEND="
	>=dev-libs/glib-2.50.0
	>=dev-qt/qtbase-6.6:6
"
RDEPEND="${DEPEND}
	!<=app-arch/lxqt-archiver-1
	!<=app-misc/qtxdg-tools-4
	!<=dev-libs/libqtxdg-4
	!<=gui-libs/xdg-desktop-portal-lxqt-1
	!<=lxqt-base/liblxqt-2
	!<=lxqt-base/libsysstat-1
	!<=lxqt-base/lxqt-about-2
	!<=lxqt-base/lxqt-admin-2
	!<=lxqt-base/lxqt-config-2
	!<=lxqt-base/lxqt-globalkeys-2
	!<=lxqt-base/lxqt-menu-data-2
	!<=lxqt-base/lxqt-meta-2
	!<=lxqt-base/lxqt-notificationd-2
	!<=lxqt-base/lxqt-openssh-askpass-2
	!<=lxqt-base/lxqt-panel-2
	!<=lxqt-base/lxqt-policykit-2
	!<=lxqt-base/lxqt-powermanagement-2
	!<=lxqt-base/lxqt-qtplugin-2
	!<=lxqt-base/lxqt-runner-2
	!<=lxqt-base/lxqt-session-2
	!<=lxqt-base/lxqt-sudo-2
	!<=media-gfx/lximage-qt-2
	!<=media-sound/pavucontrol-qt-2
	!<=x11-libs/libfm-qt-2
	!<=x11-libs/qtermwidget-2
	!x11-misc/obconf-qt
	!<=x11-misc/pcmanfm-qt-2
	!<=x11-misc/qps-2.9
	!<=x11-misc/screengrab-2.8
	!<=x11-terms/qterminal-2
	!<=x11-themes/lxqt-themes-2
"
