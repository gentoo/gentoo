# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="C-family abstract syntax tree XML output tool"
HOMEPAGE="https://github.com/CastXML/CastXML"
SRC_URI="https://github.com/CastXML/CastXML/archive/v${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/CastXML-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"
IUSE="+man test"

RESTRICT="!test? ( test )"

RDEPEND="
		sys-devel/llvm:=
		sys-devel/clang:=
	"
DEPEND="${RDEPEND}"
BDEPEND="
		${RDEPEND}
		man? ( dev-python/sphinx )
	"

src_configure() {
	local mycmakeargs=(
		-DCastXML_INSTALL_DOC_DIR="share/doc/${P}"
		-DCastXML_INSTALL_MAN_DIR="share/man"
		-DSPHINX_MAN="$(usex man)"
		-DSPHINX_HTML=OFF
		-DBUILD_TESTING="$(usex test)"
	)
	cmake_src_configure
}
