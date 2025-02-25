# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="false"
ECM_I18N="false"
KDE_ORG_NAME="${PN/login-sessions/workspace}"
inherit ecm-common plasma.kde.org

DESCRIPTION="KDE Plasma login sessions"

LICENSE="GPL-2" # TODO: CHECK
SLOT="6"
KEYWORDS="~amd64 ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="+wayland X"

REQUIRED_USE="|| ( wayland X )"

RDEPEND="!<kde-plasma/plasma-workspace-6.2.1"

ecm-common_inject_heredoc() {
	cat >> CMakeLists.txt <<- _EOF_ || die
		add_subdirectory(login-sessions)
	_EOF_
}

src_configure() {
	local mycmakeargs=(
		-DKDE_INSTALL_LIBEXECDIR=/usr/libexec # temp. workaround, bug 941502
		-DPLASMA_X11_DEFAULT_SESSION=$(usex !wayland)
	)
	ecm-common_src_configure
}

src_install() {
	cmake_src_install
	if ! use wayland; then
		rm -rv "${ED}"/usr/share/wayland-sessions || die
	fi
	if ! use X; then
		rm -rv "${ED}"/usr/share/xsessions || die
	fi
}
