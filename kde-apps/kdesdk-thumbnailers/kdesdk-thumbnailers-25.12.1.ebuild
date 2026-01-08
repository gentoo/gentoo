# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KFMIN=6.19.0
QTMIN=6.9.1
inherit ecm gear.kde.org

DESCRIPTION="Thumbnail generator for PO files"

LICENSE="GPL-2" # TODO: CHECK
SLOT="6"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
IUSE=""

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[gui,widgets]
	>=kde-frameworks/kio-${KFMIN}:6
	sys-devel/gettext
"
RDEPEND="${DEPEND}
	!<kde-apps/kdesdk-thumbnailers-24.05.2-r1:5
	!kde-apps/kdesdk-thumbnailers-common
"
