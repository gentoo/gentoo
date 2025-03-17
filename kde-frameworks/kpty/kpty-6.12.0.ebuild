# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit ecm frameworks.kde.org

DESCRIPTION="Framework for pseudo terminal devices and running child processes"

LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
IUSE=""

DEPEND="
	=kde-frameworks/kcoreaddons-${KDE_CATV}*:6
	=kde-frameworks/ki18n-${KDE_CATV}*:6
	sys-libs/libutempter
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DUTEMPTER_EXECUTABLE="${EPREFIX}/usr/sbin/utempter"
	)

	ecm_src_configure
}
