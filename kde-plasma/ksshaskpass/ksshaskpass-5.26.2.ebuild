# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KFMIN=5.99.0
QTMIN=5.15.5
inherit ecm plasma.kde.org

DESCRIPTION="Implementation of ssh-askpass with KDE Wallet integration"
HOMEPAGE+=" https://invent.kde.org/plasma/ksshaskpass"

LICENSE="GPL-2" # TODO: CHECK
SLOT="5"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv"
IUSE=""

DEPEND="
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kwallet-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
"
RDEPEND="${DEPEND}"

src_install() {
	ecm_src_install

	insinto /etc/xdg/plasma-workspace/env/
	doins "${FILESDIR}/05-ksshaskpass.sh"
}

pkg_postinst() {
	ecm_pkg_postinst

	elog "In order to have ssh-agent start with Plasma 5,"
	elog "edit /etc/xdg/plasma-workspace/env/10-agent-startup.sh"
	elog "and uncomment the lines enabling ssh-agent."
	elog
	elog "If you do so, do not forget to uncomment the respective"
	elog "lines in /etc/xdg/plasma-workspace/shutdown/10-agent-shutdown.sh"
	elog "to properly kill the agent when the session ends."
	elog
	elog "${PN} has been installed as your default askpass application"
	elog "for Plasma 5 sessions."
	elog "If that's not desired, select the one you want to use in"
	elog "/etc/xdg/plasma-workspace/env/05-ksshaskpass.sh"

	# Clean up pre-5.17.4 dirs
	rmdir -v "${EROOT}"/etc/plasma{/startup,} 2> /dev/null
}
