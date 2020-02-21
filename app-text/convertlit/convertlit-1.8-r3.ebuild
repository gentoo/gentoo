# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

MY_P="clit${PV//./}"

DESCRIPTION="CLit converts MS ebook .lit files to .opf (xml+html+png+jpg)"
HOMEPAGE="http://www.convertlit.com/"
SRC_URI="http://www.convertlit.com/${MY_P}src.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 hppa ~ia64 ppc ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

RDEPEND=">=dev-libs/libtommath-0.36-r1"

DEPEND="${RDEPEND}
	app-arch/unzip"

S="${WORKDIR}"

PATCHES=(
	"${FILESDIR}/${P}-respectflags-r1.patch"
	"${FILESDIR}/fix-Wformat-security-warnings.patch"
	"${FILESDIR}/support-ar-variable.patch"
)

src_compile() {
	tc-export CC

	cd "${S}/lib" || die "failed to change into ${S}/lib directory"
	emake
	cd "${S}/${MY_P}" || die "failed to change into ${S}/${MY_P} directory"
	emake
}

src_install() {
	einstalldocs
	dobin "${MY_P}/clit"
}
