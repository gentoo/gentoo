# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake edo

DESCRIPTION="Gradually typed embeddable scripting language derived from Lua"
HOMEPAGE="https://luau.org/
	https://github.com/luau-lang/luau/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/luau-lang/${PN}.git"
else
	SRC_URI="https://github.com/luau-lang/${PN}/archive/${PV}.tar.gz
		-> ${P}.tar.gz"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="MIT"
SLOT="0"
IUSE="static-libs test"
RESTRICT="!test? ( test )"

DOCS=( CONTRIBUTING.md README.md SECURITY.md )

src_configure() {
	local -a mycmakeargs=(
		-DLUAU_BUILD_TESTS="$(usex test)"
	)
	cmake_src_configure
}

src_test() {
	edo "${BUILD_DIR}/Luau.UnitTest" --verbose
	edo "${BUILD_DIR}/Luau.Conformance" --verbose
}

src_install() {
	exeinto /usr/bin
	doexe "${BUILD_DIR}"/luau{,-analyze,-ast,-compile,-reduce}

	insinto /usr/include/Luau
	doins ./CodeGen/include/luacodegen.h
	doins ./Compiler/include/luacode.h
	doins ./VM/include/*.h
	doins ./{Config,Common,Compiler,CodeGen,Ast,Analysis,EqSat}/include/Luau/*.h

	if use static-libs ; then
		dolib.a "${BUILD_DIR}"/libLuau.*.a
	fi

	einstalldocs
}
