# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby26 ruby27"
KFMIN=5.96.0
QTMIN=5.15.5
inherit ecm gear.kde.org ruby-single

DESCRIPTION="Kross interpreter plugins for programming languages"

LICENSE="GPL-2" # TODO: CHECK
SLOT="5"
KEYWORDS="~amd64 ~arm64 ~riscv ~x86"
IUSE=""

DEPEND="
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=kde-frameworks/kross-${KFMIN}:5
	${RUBY_DEPS}
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_DISABLE_FIND_PACKAGE_PythonLibs=ON
		-DBUILD_ruby=ON
	)
	ecm_src_configure
}
