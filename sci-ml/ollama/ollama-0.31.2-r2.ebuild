# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake go-module systemd

DESCRIPTION="Get up and running with Llama 3, Mistral, Gemma, and other language models"
HOMEPAGE="https://ollama.com"

LLAMA_CPP_tag=b9888

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
BDEPEND="
	>=dev-lang/go-1.26.0
	dev-libs/stb
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.31.1-ggml.patch
	"${FILESDIR}"/${PN}-0.31.1-cmake.patch
)

src_prepare() {
	cmake_src_prepare

	local llama_src="${BUILD_DIR}/_deps/llama_cpp-src"
	local llama_patch_dir="${WORKDIR}/${P}/llama/compat"

	mkdir -p "${BUILD_DIR}"/_deps || die

	ln -s "${WORKDIR}"/llama.cpp-${LLAMA_CPP_tag} "${llama_src}" || die

	# Switch to the llama.cpp source directory
	pushd "${llama_src}" > /dev/null || die
	eapply "${llama_patch_dir}"/*.patch \
		"${llama_patch_dir}"/models/*.patch \
		"${FILESDIR}"/${PN}-0.31.1-gcc17.patch

	# Remove vendored
	rm -r vendor/stb || die
	popd > /dev/null || die
}

src_configure() {
	# Configure Embedded local Server
	local llama_src="${BUILD_DIR}/_deps/llama_cpp-src"
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${BUILD_DIR}"
		-DOLLAMA_RUNNER_DIR=""
		-DFETCHCONTENT_SOURCE_DIR_LLAMA_CPP="${llama_src}"
		-DOLLAMA_LLAMA_CPP_SKIP_COMPAT_PATCH=ON
		-DBUILD_SHARED_LIBS=ON
		-DLLAMA_USE_SYSTEM_GGML=ON
	)
	local CMAKE_USE_DIR="${S}/llama/server"
	local BUILD_DIR="${BUILD_DIR}/llama-server-local"
	cmake_src_configure
}

src_compile() {
	local SAVE_BUILD_DIR="${BUILD_DIR}"

	# Compile Embedded Local Server
	local BUILD_DIR="${BUILD_DIR}"/llama-server-local
	local cmake_src_compile_opts=(
		--target llama-server
		--target llama-quantize
	)
	cmake_src_compile

	# Install/Stage Local Server Component
	"${CMAKE_BINARY}" \
		--install "${BUILD_DIR}" \
		--prefix "${SAVE_BUILD_DIR}" \
		--component llama-server \
		|| die "Failed to stage server component"

	# Expose CGO to Go and establish compiler optimization paths
	export CGO_ENABLED=1

	# Replicate the linker flags dynamically from your ebuild version
	local mygoldflags="-X github.com/ollama/ollama/version.Version=${PV} \
		-X github.com/ollama/ollama/server.mode=release"

	# Call the Go build engine natively with standard Gentoo flags
	ego build \
		-trimpath \
		-ldflags "${mygoldflags}" \
		-o "${BUILD_DIR}/ollama" \
		. || die "Go build failed"
}

src_install() {
	dobin "${BUILD_DIR}"/llama-server-local/ollama
	insinto usr
	doins -r "${BUILD_DIR}"/lib
	fperms 0755 /usr/lib/ollama/libllama-*-impl.so
	fperms 0755 /usr/lib/ollama/lib*.so.0.0.0
	fperms 0755 /usr/lib/ollama/llama-*

	einstalldocs

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
