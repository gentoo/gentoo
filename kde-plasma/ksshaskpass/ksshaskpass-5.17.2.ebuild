# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit kde5

DESCRIPTION="KDE implementation of ssh-askpass with Kwallet integration"
HOMEPAGE="https://cgit.kde.org/ksshaskpass.git"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE=""

DEPEND="
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kwallet)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_qt_dep qtwidgets)
"
RDEPEND="${DEPEND}"

src_install() {
	kde5_src_install

	insinto /etc/xdg/plasma-workspace/env/
	doins "${FILESDIR}/05-ksshaskpass.sh"
}

pkg_postinst() {
	kde5_pkg_postinst

	elog "${PN} has been installed as your default askpass application"
	elog "for Plasma 5 sessions."
	elog "If that's not desired, select the one you want to use in"
	elog
	elog "/etc/xdg/plasma-workspace/env/05-ksshaskpass.sh (ATTN: Path moved!)"
	elog
	elog "In order to have ssh-agent start with Plasma 5, do the following:"
	elog " * Copy the necessary files to your home directory:"
	elog "   - cp /etc/plasma/startup/10-agent-startup.sh ~/.config/plasma-workspace/env/"
	elog "   - cp /etc/plasma/shutdown/10-agent-shutdown.sh ~/.config/plasma-workspace/shutdown/"
	elog " * Edit 10-agent-startup.sh and uncomment the lines enabling ssh-agent."
	elog " * In 10-agent-shutdown.sh uncomment the respective lines to properly kill"
	elog "   the agent when the session ends."
}
