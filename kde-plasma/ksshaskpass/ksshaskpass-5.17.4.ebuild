# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KFMIN=5.64.0
PVCUT=$(ver_cut 1-3)
QTMIN=5.12.3
inherit ecm kde.org

DESCRIPTION="KDE implementation of ssh-askpass with Kwallet integration"
HOMEPAGE="https://cgit.kde.org/ksshaskpass.git"
LICENSE="GPL-2" # TODO: CHECK
SLOT="5"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE=""

DEPEND="
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kwallet-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
"
RDEPEND="${DEPEND}"

src_install() {
	ecm_src_install

	insinto /etc/xdg/plasma-workspace/env/
	doins "${FILESDIR}/05-ksshaskpass.sh"
}

pkg_postinst() {
	ecm_pkg_postinst

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
