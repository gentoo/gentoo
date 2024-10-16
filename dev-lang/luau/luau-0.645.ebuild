# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

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
IUSE="test"
RESTRICT="!test? ( test )"
DOCS=( CONTRIBUTING.md README.md SECURITY.md )

src_test() {
	"${BUILD_DIR}/Luau.UnitTest" || die
	"${BUILD_DIR}/Luau.Conformance" || die
}

src_configure() {
	local mycmakeargs=(
		-DLUAU_BUILD_TESTS=$(usex test)
	)
	cmake_src_configure
}

src_install() {
	dolib.a "${BUILD_DIR}"/libLuau.*.a

	exeinto /usr/bin
	doexe "${BUILD_DIR}"/luau{,-analyze,-ast,-compile,-reduce}

	insinto /usr/include/Luau
	doins "${S}"/VM/include/*.h
	doins "${S}"/Compiler/include/luacode.h
	doins "${S}"/CodeGen/include/luacodegen.h
	doins "${S}"/{Config,Common,Compiler,CodeGen,Ast,Analysis,EqSat}/include/Luau/*.h

	einstalldocs
}
