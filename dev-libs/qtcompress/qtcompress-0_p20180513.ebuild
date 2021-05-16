# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit qmake-utils toolchain-funcs virtualx

DESCRIPTION="A public API for QZip in an easy to use module"

HOMEPAGE="https://github.com/nezticle/qtcompress"
MY_COMMIT="23f8831826cd72aedf99fc3699148b6c994fd677"
SRC_URI="https://github.com/nezticle/qtcompress/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/qtcompress-${MY_COMMIT}"

LICENSE="|| ( LGPL-2.1 GPL-3 ) FDL-1.3"
SLOT="0/5.11.0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-qt/qtcore:5
	sys-libs/zlib
"
DEPEND="
	${RDEPEND}
	test? ( dev-qt/qttest:5 )
"
BDEPEND="
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}/${P}-remove-zlib.patch"
	"${FILESDIR}/${P}-test-include.patch"
	"${FILESDIR}/${P}-nogui.patch"
)

src_prepare() {
	default
	# qtcompress is bundling its own zlib, remove it
	rm -r src/3rdparty/ || die
}

src_configure() {
	local pkg_config="$(tc-getPKG_CONFIG)"
	eqmake5 \
		"INCLUDEPATH+=$("${pkg_config}" --cflags zlib)" \
		"LIBS+=$("${pkg_config}" --libs zlib)"
}

src_test() {
	cd tests/auto/unit || die
	eqmake5 \
		"INCLUDEPATH+=${S}/src/compress"
	emake
	virtx qzip/target_wrapper.sh qzip/tst_qzip
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	rm "${ED}/usr/$(get_libdir)/libQt5Compress.la" || die
	insinto /usr/include/qt5/QtCompress
	doins src/compress/{qzipreader.h,qzipwriter.h,qtcompressglobal.h}
}
