# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby25 ruby26 ruby27"
KFMIN=5.75.0
QTMIN=5.15.2
inherit ecm kde.org ruby-single

DESCRIPTION="Kross interpreter plugins for programming languages"

LICENSE="GPL-2" # TODO: CHECK
SLOT="5"
KEYWORDS="~amd64 ~arm64 ~x86"
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
