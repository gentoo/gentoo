# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit qmake-utils

DESCRIPTION="Read current clocks of ATi/AMD Radeon cards"
HOMEPAGE="https://github.com/marazmista/radeon-profile"
if [[ "${PV}" == 99999999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/marazmista/radeon-profile.git"
else
	SRC_URI="https://github.com/marazmista/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi
LICENSE="GPL-2"
SLOT="0"

IUSE=""

S="${WORKDIR}/${P}/${PN}"

RDEPEND="
	dev-qt/qtcharts:5
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	x11-libs/libX11
	x11-libs/libXrandr
"

DEPEND="
	${RDEPEND}
	dev-qt/qtconcurrent:5
	media-libs/mesa[X(+)]
	x11-libs/libdrm
"

src_prepare() {
	default
	sed 's@TrayIcon;@@' -i extra/${PN}.desktop || die
}

src_configure() {
	eqmake5
}

src_install() {
	emake INSTALL_ROOT="${D}" install
}

pkg_postinst() {
	elog "In order to run ${PN} as non-root user, the"
	elog "  x11-apps/radeon-profile-daemon"
	elog "package needs to be installed and the daemon must run."
}
