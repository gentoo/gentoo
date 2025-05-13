# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
DISTUTILS_EXT=1
PYTHON_COMPAT=( python3_{11..13} )
inherit cmake distutils-r1

DESCRIPTION="Text tokenizer for Neural Network-based text generation"
HOMEPAGE="https://github.com/google/sentencepiece"
SRC_URI="https://github.com/google/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-cpp/abseil-cpp:=
	dev-libs/protobuf:=
	dev-util/google-perftools
	!sci-ml/pysentencepiece
"
DEPEND="${RDEPEND}
	dev-libs/darts
"

DOCS=(
	README.md
	doc/api.md
	doc/experiments.md
	doc/normalization.md
	doc/options.md
	doc/special_symbols.md
)

src_prepare() {
	sed -i \
		-e "s:third_party/darts_clone/darts.h:darts.h:" \
		src/model_interface.h \
		src/normalizer.h \
		src/normalizer.cc \
		src/unigram_model.h \
		src/builder.cc \
		|| die
	eapply "${FILESDIR}"/${P}-gcc15.patch
	cmake_src_prepare
	distutils-r1_src_prepare
	sed \
		-e 's|@libprotobuf_lite@|protobuf-lite|' \
		-e "s|@includedir_for_pc_file@|${S}/src|" \
		-e "s|@libdir_for_pc_file@|${BUILD_DIR}/src|" \
		${PN}.pc.in \
		> python/${PN}.pc \
		|| die
	sed -i \
		-e '/cmake_minimum_required/s:3.1:3.10:' \
		CMakeLists.txt \
		|| die

}

src_configure() {
	local mycmakeargs=(
		-DSPM_ABSL_PROVIDER=package
		-DSPM_PROTOBUF_PROVIDER=package
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	cd python
	PKG_CONFIG_PATH=. distutils-r1_src_compile
}

src_test() {
	LD_LIBRARY_PATH=${BUILD_DIR}/src distutils-r1_src_test
}

python_test() {
	cd python
	${EPYTHON} test/sentencepiece_test.py || die
}

src_install() {
	cmake_src_install
	distutils-r1_src_install
}
