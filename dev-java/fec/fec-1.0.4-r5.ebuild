# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"

inherit flag-o-matic toolchain-funcs java-pkg-2 java-pkg-simple

DESCRIPTION="Forward Error Correction library in Java"
HOMEPAGE="https://github.com/hyphanet/contrib/blob/master/README"
SRC_URI="https://dev.gentoo.org/~monsieurp/packages/${P}.tar.gz"
S="${WORKDIR}/${P}"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

CP_DEPEND="dev-java/log4j-12-api:2"

RDEPEND="${CP_DEPEND}
	>=virtual/jre-1.8:*"

DEPEND="${CP_DEPEND}
	>=virtual/jdk-1.8:*"

PATCHES=(
	"${FILESDIR}"/"${P}-libfec8path.patch"
	"${FILESDIR}"/"${P}-build.patch"
	"${FILESDIR}"/"${P}-soname.patch"
	"${FILESDIR}"/"${P}-remove-concurrent-util-imports.patch"
)

JAVA_RESOURCE_DIRS="bin"
JAVA_SRC_DIR="src"

src_prepare() {
	default #780585
	java-pkg-2_src_prepare
	java-pkg_clean

	# tests have never been enabled on this package. anyway, keeping this
	# package with sources hosted in dev-space is only a workaround until
	# we have a solution for bug #936539. the time for bothering with tests
	# should be saved for that part.
	#
	# for the time being we keep removing the tests like before.
	rm -rf tests || die
}

src_compile() {
	java-pkg-simple_src_compile
	einfo "Sucessfully compiled Java classes!"

	cd "${S}"/src/csrc || die
	append-flags -fPIC
	emake CC=$(tc-getCC) CFLAGS="${CFLAGS} $(java-pkg_get-jni-cflags)"
	einfo "Sucessfully compiled C files!"
}

src_install() {
	java-pkg-simple_src_install
	dolib.so src/csrc/libfec{8,16}.so
}
