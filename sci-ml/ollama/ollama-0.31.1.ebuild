# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake go-module

DESCRIPTION="Get up and running with Llama 3, Mistral, Gemma, and other language models."
HOMEPAGE="https://ollama.com"

LLAMA_CPP_tag=b9840

SRC_URI="
	https://github.com/ollama/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz
	https://github.com/gentoo-golang-dist/${PN}/releases/download/v${PV}/${P}-deps.tar.xz
	https://github.com/ggml-org/llama.cpp/archive/refs/tags/${LLAMA_CPP_tag}.tar.gz -> llama.cpp-${LLAMA_CPP_tag}.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="mirror test"

DEPEND="
	sci-ml/ggml
"
RDEPEND="
	${DEPEND}
	net-misc/curl:=
"
BDEPEND=">=dev-lang/go-1.26.0"

PATCHES=(
	"${FILESDIR}"/${P}-ggml.patch
	"${FILESDIR}"/${P}-llamaDL.patch
	"${FILESDIR}"/${P}-cmake.patch
)

src_prepare() {
	cmake_src_prepare
	cd ..
	eapply "${FILESDIR}"/${P}-gcc17.patch
}

src_configure() {
	local mycmakeargs=(
		-DLLAMA_USE_SYSTEM_GGML=ON
	)

	cmake_src_configure
	rm -rf "${BUILD_DIR}"/_deps/llama_cpp-src || die
	ln -s "${WORKDIR}"/llama.cpp-${LLAMA_CPP_tag} \
		"${BUILD_DIR}"/_deps/llama_cpp-src || die
}

src_install() {
	cmake_src_install
	rm -rf "${D}"/var || die
}
