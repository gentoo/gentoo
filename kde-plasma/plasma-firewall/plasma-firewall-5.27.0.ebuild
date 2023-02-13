# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="forceoptional"
PYTHON_COMPAT=( python3_{9..11} )
KFMIN=5.102.0
QTMIN=5.15.7
inherit ecm plasma.kde.org python-single-r1

DESCRIPTION="Plasma frontend for Firewalld or UFW"
HOMEPAGE="https://invent.kde.org/network/plasma-firewall"

LICENSE="GPL-2+"
SLOT="5"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="firewalld +ufw"

REQUIRED_USE="${PYTHON_REQUIRED_USE} || ( firewalld ufw )"

DEPEND="
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtx11extras-${QTMIN}:5
	>=dev-qt/qtxml-${QTMIN}:5
	>=kde-frameworks/kauth-${KFMIN}:5
	>=kde-frameworks/kcmutils-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kdeclarative-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
"
RDEPEND="${DEPEND}
	${PYTHON_DEPS}
	firewalld? ( net-firewall/firewalld )
	ufw? ( net-firewall/ufw )
"
BDEPEND=">=kde-frameworks/kcmutils-${KFMIN}:5"

src_prepare() {
	ecm_src_prepare
	# this kind of cmake magic doesn't work for us at all.
	sed -e "1 s:^.*$:\#\!/usr/bin/env ${EPYTHON}:" \
		-i kcm/backends/ufw/helper/kcm_ufw_helper.py.cmake || die
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_FIREWALLD_BACKEND=$(usex firewalld)
		-DBUILD_UFW_BACKEND=$(usex ufw)
	)
	ecm_src_configure
}

pkg_postinst () {
	ecm_pkg_postinst

	if ! has_version sys-apps/systemd; then
		ewarn "${PN} is not functional without sys-apps/systemd at this point."
		ewarn "See also: https://bugs.gentoo.org/778527"
	fi
}
