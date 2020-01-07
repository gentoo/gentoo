# Copyright 1999-2020 Gentoo Authors
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
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kwallet-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
"
RDEPEND="${DEPEND}"

pkg_setup() {
	ecm_pkg_setup

	local srcfile=/etc/plasma/startup/05-ksshaskpass.sh
	local newfile=/etc/xdg/plasma-workspace/env/05-ksshaskpass.sh
	if [[ -f "${EROOT}"${srcfile} ]]; then
		local md5=$(md5sum "${EROOT}"${srcfile})
		if [[ ${md5%% *} != 615ae8f5b0090ff7f51d0edee7885d55 ]]; then
			elog "Existing modified "${EPREFIX}"${srcfile} detected."
			elog "Copying to "${EPREFIX}"${newfile}..."
			cp -v "${EROOT}"${srcfile} "${T}"/ || die
		fi
	fi
}

src_prepare() {
	ecm_src_prepare
	if [[ ! -f "${T}"/05-ksshaskpass.sh ]]; then
		cp "${FILESDIR}"/05-ksshaskpass.sh "${T}"/ || die
	fi
}

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

	# Clean up pre-5.17.4 script
	if [[ -e "${EROOT}"/etc/plasma/startup/05-ksshaskpass.sh ]]; then
		rm "${EROOT}"/etc/plasma/startup/05-ksshaskpass.sh || die
		elog "Removed obsolete ${EPREFIX}/etc/plasma/startup/05-ksshaskpass.sh"
	fi
}
