# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="GObject-Introspection C++ binding wrapper generator"
HOMEPAGE="https://gitlab.com/mnauw/cppgir"

MY_PV="960fe054ffaab7cf55722fea6094c56a8ee8f18e"
SRC_URI="https://gitlab.com/mnauw/cppgir/-/archive/${MY_PV}/cppgir-${MY_PV}.tar.bz2 -> ${P}.tar.bz2"
S="${WORKDIR}/${PN}-${MY_PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~riscv"
IUSE="doc test"
RESTRICT="!test? ( test )"

DEPEND="
	dev-cpp/expected-lite
	dev-libs/boost:=
	dev-libs/libfmt:=
"
BDEPEND="
	doc? ( app-text/ronn-ng )
"

PATCHES=(
	"${FILESDIR}/cppgir-0_p20230606-system-expected-lite.patch"
	"${FILESDIR}/cppgir-0_p20230606-fix-install-paths.patch"
	"${FILESDIR}/cppgir-0_p20230606-prevent-automagic.patch"
)

src_configure() {
	local mycmakeargs=(
		-DBUILD_DOC=$(usex doc)
		-DBUILD_TESTING=$(usex test)
	)

	cmake_src_configure
}
