# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )

inherit cmake-utils python-single-r1

DESCRIPTION="GNOME Shell integration for Chrome/Chromium, Firefox, Vivaldi, Opera browsers"
HOMEPAGE="https://wiki.gnome.org/Projects/GnomeShellIntegrationForChrome"
SRC_URI="mirror://gnome/sources/${PN}/${PV}/${P}.tar.xz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~x86"
IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}
	app-misc/jq
	sys-apps/coreutils
"
RDEPEND="${PYTHON_DEPS}
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	gnome-base/gnome-shell
"

src_configure() {
	local mycmakeargs=( -DBUILD_EXTENSION=OFF )
	cmake-utils_src_configure
}

pkg_postinst() {
	elog "Please note that this package provides native messaging connector only."
	elog "You can install browser extension using link provided at"
	elog "https://extensions.gnome.org website."
}
