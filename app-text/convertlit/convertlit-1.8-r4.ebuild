# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

MY_P="clit${PV//./}"

DESCRIPTION="CLit converts MS ebook .lit files to .opf (xml+html+png+jpg)"
HOMEPAGE="http://www.convertlit.com/"
SRC_URI="http://www.convertlit.com/${MY_P}src.zip"
S="${WORKDIR}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~ia64 ppc ppc64 ~riscv x86 ~amd64-linux ~x86-linux ~ppc-macos"

RDEPEND=">=dev-libs/libtommath-0.36-r1"
DEPEND="${RDEPEND}"
BDEPEND="app-arch/unzip"

PATCHES=(
	"${FILESDIR}"/${P}-respectflags-r1.patch
	"${FILESDIR}"/fix-Wformat-security-warnings.patch
	"${FILESDIR}"/support-ar-variable.patch
)

src_compile() {
	tc-export AR CC

	emake -C lib
	emake -C ${MY_P}
}

src_install() {
	dobin ${MY_P}/clit
	einstalldocs
}
