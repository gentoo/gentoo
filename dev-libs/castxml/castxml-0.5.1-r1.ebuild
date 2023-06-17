# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_MAX_SLOT=15
inherit cmake llvm

DESCRIPTION="C-family abstract syntax tree XML output tool"
HOMEPAGE="https://github.com/CastXML/CastXML"
SRC_URI="https://github.com/CastXML/CastXML/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/CastXML-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~riscv ~x86"
IUSE="+man test"
RESTRICT="!test? ( test )"

# See comment in llvm.eclass for why we don't depend on LLVM if we already
# depend on Clang.
RDEPEND="
	<sys-devel/clang-$((LLVM_MAX_SLOT + 1)):=
"
DEPEND="${RDEPEND}"
BDEPEND="
	${RDEPEND}
	man? ( dev-python/sphinx )
"

PATCHES=(
	"${FILESDIR}"/${PN}-fix-tests.patch
)

llvm_check_deps() {
	has_version "sys-devel/clang:${LLVM_SLOT}"
}

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
