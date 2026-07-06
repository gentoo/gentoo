# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake go-module systemd

DESCRIPTION="Get up and running with Llama 3, Mistral, Gemma, and other language models."
HOMEPAGE="https://ollama.com"

LLAMA_CPP_tag=b9840

SRC_URI="
	https://github.com/ollama/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz
	https://github.com/gentoo-golang-dist/${PN}/releases/download/v${PV}/${P}-deps.tar.xz
	https://github.com/ggml-org/llama.cpp/archive/refs/tags/${LLAMA_CPP_tag}.tar.gz
		-> llama.cpp-${LLAMA_CPP_tag}.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="mirror test"

DEPEND="
	acct-group/ollama
	acct-user/ollama
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

	newinitd "${FILESDIR}/ollama.init" "${PN}"
	newconfd "${FILESDIR}/ollama.confd" "${PN}"

	systemd_dounit "${FILESDIR}/ollama.service"
}

pkg_preinst() {
	keepdir /var/log/ollama
	fperms 750 /var/log/ollama
	fowners "${PN}:${PN}" /var/log/ollama
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]] ; then
		einfo "Quick guide:"
		einfo "\tollama serve"
		einfo "\tollama run llama3:70b"
		einfo
		einfo "See available models at https://ollama.com/library"
	fi

	einfo
	einfo "Ollama binds 127.0.0.1 port 11434 by default."
	einfo "Change the bind address with the OLLAMA_HOST environment variable."
	einfo "See https://docs.ollama.com/faq for more info"
	einfo
}
