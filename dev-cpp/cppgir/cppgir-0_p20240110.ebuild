# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic

DESCRIPTION="GObject-Introspection C++ binding wrapper generator"
HOMEPAGE="https://gitlab.com/mnauw/cppgir"

MY_PV="8ab6357089759d20140942de0d6d15739fface04"
SRC_URI="https://gitlab.com/mnauw/cppgir/-/archive/${MY_PV}/cppgir-${MY_PV}.tar.bz2 -> ${P}.tar.bz2"
S="${WORKDIR}/${PN}-${MY_PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~loong ~ppc64 ~riscv"
IUSE="doc test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/boost:=
	dev-libs/libfmt:=
"
DEPEND="${RDEPEND}
	dev-cpp/expected-lite
"
BDEPEND="
	doc? ( app-text/ronn-ng )
	test? ( dev-libs/glib )
"

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
