# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

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

PATCHES=( "${FILESDIR}"/${P}-gcc15.patch )

src_prepare() {
	sed -i \
		-e "s:third_party/darts_clone/darts.h:darts.h:" \
		src/model_interface.h \
		src/normalizer.h \
		src/normalizer.cc \
		src/unigram_model.h \
		src/builder.cc \
		|| die
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DSPM_ABSL_PROVIDER=package
		-DSPM_PROTOBUF_PROVIDER=package
	)
	cmake_src_configure
}
