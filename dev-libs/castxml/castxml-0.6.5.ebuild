# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_COMPAT=( {17..19} )

inherit cmake llvm-r1

MY_P=CastXML-${PV}
DESCRIPTION="C-family abstract syntax tree XML output tool"
HOMEPAGE="https://github.com/CastXML/CastXML"
SRC_URI="
	https://github.com/CastXML/CastXML/archive/v${PV}.tar.gz
		-> ${MY_P}.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~riscv ~x86"
IUSE="+man test"
RESTRICT="!test? ( test )"

DEPEND="
	$(llvm_gen_dep '
		sys-devel/clang:${LLVM_SLOT}=
	')
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	man? ( dev-python/sphinx )
"

src_configure() {
	local mycmakeargs=(
		-DCastXML_INSTALL_DOC_DIR="share/doc/${PF}"
		-DCastXML_INSTALL_MAN_DIR="share/man"
		-DSPHINX_MAN="$(usex man)"
		-DSPHINX_HTML=OFF
		-DBUILD_TESTING="$(usex test)"
	)
	cmake_src_configure
}

src_test() {
	local CMAKE_SKIP_TESTS=(
		# Regex doesn't match the full build path
		cmd.input-missing
		cmd.rsp-missing

		# Gets confused by extra #defines we set for hardening etc (bug #891813)
		cmd.cc-gnu-src-cxx-E
		cmd.cc-gnu-src-cxx-cmd
		cmd.cc-gnu-c-src-c-E
		cmd.cc-gnu-c-src-c-cmd
	)

	cmake_src_test
}
