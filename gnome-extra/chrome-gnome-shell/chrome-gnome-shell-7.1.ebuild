# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5} )

inherit cmake-utils python-single-r1

DESCRIPTION="GNOME Shell integration for Chrome/Chromium, Vivaldi, Opera browsers"
HOMEPAGE="https://wiki.gnome.org/Projects/GnomeShellIntegrationForChrome"
SRC_URI="mirror://gnome/sources/${PN}/${PV}/${P}.tar.xz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}
	sys-apps/coreutils
"
RDEPEND="${PYTHON_DEPS}
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	gnome-base/gnome-shell
"

src_configure() {
	local mycmakeargs=( -DBUILD_EXTENSION=OFF )
	cmake-utils_src_configure
}

src_install() {
	# Chrome policy files should be removed with package.
	# Otherwise it will not be possible to uninstall web extension
	# from browser.
	echo -n "CONFIG_PROTECT_MASK=\"" > 50"${PN}" || die
	echo -n "/etc/chromium/policies/managed/${PN}.json " >> 50"${PN}" || die
	echo "/etc/opt/chrome/policies/managed/${PN}.json\"" >> 50"${PN}" || die
	doenvd 50"${PN}"

	cmake-utils_src_install
}
