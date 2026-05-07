# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_QA_COMPAT_SKIP=1 # unused bundled rapidjson
inherit cmake

DESCRIPTION="Embeddable Fulltext Search Engine"
HOMEPAGE="https://groonga.org/"
SRC_URI="https://packages.groonga.org/source/groonga/${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="apache-arrow blosc curl debug json libedit lz4 +mecab msgpack stemmer suggest-learner xxhash zstd"
CPU_USE=(
	cpu_flags_x86_{avx,avx2,avx512dq}
)
IUSE+=" ${CPU_USE[@]}"
REQUIRED_USE="suggest-learner? ( msgpack )"

RDEPEND="
	acct-group/groonga
	acct-user/groonga
	dev-libs/onigmo:=
	virtual/zlib:=
	apache-arrow? ( dev-libs/apache-arrow:= )
	blosc? ( >=dev-libs/c-blosc2-2.10.0:= )
	curl? ( net-misc/curl )
	libedit? ( dev-libs/libedit )
	lz4? ( app-arch/lz4:= )
	mecab? ( app-text/mecab )
	msgpack? ( dev-libs/msgpack:= )
	stemmer? ( dev-libs/snowball-stemmer:= )
	suggest-learner? (
		dev-libs/libevent:=
		net-libs/zeromq:=
	)
	xxhash? ( >=dev-libs/xxhash-0.8.0 )
	zstd? ( app-arch/zstd:= )
"
DEPEND="
	${RDEPEND}
	amd64? ( dev-cpp/xsimd )
	json? ( dev-libs/rapidjson:= )
"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-16.0.1-cmakelists.patch
	"${FILESDIR}"/${PN}-16.0.1-blosc2_detection.patch

	# PR merged
	"${FILESDIR}"/${P}-fix_lto.patch
)

src_prepare() {
	cmake_src_prepare
	cmake_comment_add_subdirectory vendor
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_SKIP_RPATH=TRUE
		-DCMAKE_INSTALL_DOCDIR="${EPREFIX}/usr/share/doc/${PF}/html"
		-DCMAKE_INSTALL_SYSCONFDIR="${EPREFIX}/etc"

		-DGRN_ALLOW_WARNING=ON # avoid -Werror
		-DGRN_EMBED=OFF # static
		-DGRN_FOR_RHEL=OFF # TODO: adapt systemd unit
		-DGRN_LOG_PATH="${EPREFIX}/var/log/${PN}.log"

		# always OFF
		-DGRN_WITH_BENCHMARKS=OFF # install nothing
		-DGRN_WITH_BUNDLED_ONIGMO=OFF
		-DGRN_WITH_BUNDLED_MESSAGE_PACK=OFF
		-DGRN_WITH_LTO=OFF # handled by userflags
		-DGRN_WITH_SIMDJSON=no # prefer rapidjson, unlike upstream
		-DGRN_WITH_SIMSIMD=OFF # masked, old 3.8.0 bundled
		-DGRN_WITH_UBSAN=OFF # it requires clang
		-DGRN_WITH_WINDOWS_BACK_TRACE=OFF # only for windows

		# always ON
		-DGRN_WITH_DOC=ON # precompiled
		-DGRN_WITH_EXAMPLES=ON # nothing to build
		-DGRN_WITH_NFKC=ON # required for libgroonga #946976
		-DGRN_WITH_TOOLS=ON # install ruby and bash scripts
		-DGRN_WITH_ZLIB=ON # try to find zlib anyway

		-DGRN_WITH_APACHE_ARROW=$(usex apache-arrow)
		-DGRN_WITH_BLOSC=$(usex blosc system no)
		-DGRN_WITH_CURL=$(usex curl system no)
		-DGRN_WITH_MEMORY_DEBUG=$(usex debug)
		-DGRN_WITH_RAPIDJSON=$(usex json system no)
		-DGRN_WITH_LIBEDIT=$(usex libedit system no)
		-DGRN_WITH_LZ4=$(usex lz4 system no)
		-DGRN_WITH_MECAB=$(usex mecab)
		-DGRN_WITH_MESSAGE_PACK=$(usex msgpack)
		-DGRN_WITH_LIBSTEMMER=$(usex stemmer)
		-DGRN_WITH_LIBEVENT=$(usex suggest-learner)
		-DGRN_WITH_ZEROMQ=$(usex suggest-learner)
		-DGRN_WITH_XXHASH=$(usex xxhash system no)
		-DGRN_WITH_ZSTD=$(usex zstd system no)

		# TODO
		-DGRN_WITH_MRUBY=OFF
		-DGRN_WITH_MUNIN_PLUGINS=OFF

		# not packaged in ::gentoo
		-DGRN_WITH_BASE64=no # aklomp/base64
		-DGRN_WITH_FAISS=no # facebookresearch/faiss
		-DGRN_WITH_H3=no # uber/h3
		-DGRN_WITH_KYTEA=no # neubig/kytea
		-DGRN_WITH_LLAMA_CPP=no # ::guru
		-DGRN_WITH_OPENZL=no # facebook/openzl
		-DGRN_WITH_ROARING_BITMAPS=no # RoaringBitmap/CRoaring
		-DGRN_WITH_USEARCH=no # unum-cloud/USearch
	)

	# xsimd profiles
	if use amd64; then
		mycmakeargs+=(
			-DGRN_WITH_XSIMD=system
			-DGRN_HAVE_AVX_FLAG=$(usex cpu_flags_x86_avx)
			-DGRN_HAVE_AVX2_FLAG=$(usex cpu_flags_x86_avx2)
			-DGRN_HAVE_AVX512DQ_FLAG=$(usex cpu_flags_x86_avx512dq)
		)
	#elif use arm64
	#	mycmakeargs+=(
	#		-DGRN_WITH_XSIMD=system
	#		-DGRN_HAVE_ARCH_ARMV8_A_FLAG=$(usex cpu_flags_arm_v8)
	#	)
	else
		mycmakeargs+=( -DGRN_WITH_XSIMD=no )
	fi

	cmake_src_configure
}

src_install() {
	cmake_src_install

	newinitd "${FILESDIR}/${PN}.initd" ${PN}
	newconfd "${FILESDIR}/${PN}.confd" ${PN}

	keepdir /var/{log,lib}/${PN}
	fowners groonga:groonga /var/{log,lib}/${PN}
}
