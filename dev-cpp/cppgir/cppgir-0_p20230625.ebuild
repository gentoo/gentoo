# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic

DESCRIPTION="GObject-Introspection C++ binding wrapper generator"
HOMEPAGE="https://gitlab.com/mnauw/cppgir"

MY_PV="70b0e3d522cec60316d116dcbd919b797e85685a"
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
	test? ( dev-libs/glib )
"

PATCHES=(
	"${FILESDIR}/cppgir-0_p20230625-fix-libcxx-16.patch"
)

src_configure() {
	local mycmakeargs=(
		-DBUILD_DOC=$(usex doc)
		-DBUILD_TESTING=$(usex test)
		-DBUILD_EXAMPLES=no
		-DINTERNAL_EXPECTED=no
	)

	append-cppflags \
		-UDEFAULT_GIRPATH \
		-DDEFAULT_GIRPATH="${EPREFIX}/usr/share:${EPREFIX}/usr/local/share"

	cmake_src_configure
}
