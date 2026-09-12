# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_COMPAT=( 21 )

inherit cmake llvm-r2 systemd tmpfiles

DESCRIPTION="Column-oriented OLAP database management system for real-time analytics"
HOMEPAGE="https://clickhouse.com/"

CH_SUBMODULES=(
	"AMQP-CPP ClickHouse/AMQP-CPP 4fccd7f84318fe3a022c63a5b621a831c99e3a32"
	"FP16 Maratyszcza/FP16 0a92994d729ff76a58f692d3028ca1b64b145d91"
	"Jieba-CPP amosbird/Jieba-CPP d62beb8a19e326ff5619ea4bcd340e392dbb2ea6"
	"MeCab taku910/mecab 61b90ba6e669dc2d7d533d4a80d206f3b31d52b1"
	"NuRaft ClickHouse/NuRaft b053451b233176ef1d2b5c85a780f6ecca1ad8d6"
	"SHA3IUF brainhub/SHA3IUF fc8504750a5c2174a1874094dd05e6a0d8797753"
	"SimSIMD ClickHouse/SimSIMD e81e1c2de244061a476eaa7ac4db9ca01df4feed"
	"StringZilla ClickHouse/StringZilla 15c292ec71db5c0e3d05f3bd693a6b5ec9429db8"
	"abseil-cpp abseil/abseil-cpp 5650e9cf76d3be4318d5fa3af38ee483ddfd5e4a"
	"ai-sdk-cpp ClickHouse/ai-sdk-cpp ab06ef70baba81ba4ecf1ece038bbae96e74d4af"
	"antlr4-cpp-runtime antlr/antlr4 b91cecf6d06600433a12a12271a7985d2845d7aa"
	"arrow ClickHouse/arrow 949bccfd6c664b15dfad5b3e50e5428021852973"
	"avro ClickHouse/avro 7b7f6a5bc42e56b6f74de9fc8f52a2a629c53145"
	"aws-c-auth awslabs/aws-c-auth fc4b87655e5cd3921f18d1859193c74af4102071"
	"aws-c-cal ClickHouse/aws-c-cal 1cb9412158890201a6ffceed779f90fe1f48180c"
	"aws-c-common awslabs/aws-c-common 95515a8b1ff40d5bb14f965ca4cbbe99ad1843df"
	"aws-c-compression awslabs/aws-c-compression d8264e64f698341eb03039b96b4f44702a9b3f83"
	"aws-c-event-stream awslabs/aws-c-event-stream f43a3d24a7c1f8b50f709ccb4fdf4c7fd2827fff"
	"aws-c-http awslabs/aws-c-http a9745ea9998f679cd7456e7d23cc8820e38c97d4"
	"aws-c-io ClickHouse/aws-c-io 89a18aea93e7b13cd3bfeef46cd0398937013be7"
	"aws-c-mqtt awslabs/aws-c-mqtt 1d512d92709f60b74e2cafa018e69a2e647f28e9"
	"aws-c-s3 awslabs/aws-c-s3 e9d1bde139f88b08aaa3bf0507f443f31ccede93"
	"aws-c-sdkutils awslabs/aws-c-sdkutils f678bda9e21f7217e4bbf35e0d1ea59540687933"
	"aws-checksums awslabs/aws-checksums 1d5f2f1f3e5d013aae8810878ceb5b3f6f258c4e"
	"aws-crt-cpp ClickHouse/aws-crt-cpp 8776fd0dba27695736939f47d71b3e8ecf69a06d"
	"aws ClickHouse/aws-sdk-cpp 22f694afbdc7e9766894998c3745e23f004f8b86"
	"azure ClickHouse/azure-sdk-for-cpp 20f8b46b878718b4536a88888a182f60f665465a"
	"boost ClickHouse/boost e24b1b25e3349236a3c5aac792e3294f62eda1f2"
	"brotli ClickHouse/brotli d224526f8fa736f24b2339e6f421a142de6586c8"
	"bzip2 ClickHouse/bzip2 bf905ea2251191ff9911ae7ec0cfc35d41f9f7f6"
	"c-ares c-ares/c-ares c7a3138dcfe3bb0eaaf10c0c24c36dc66dc790ab"
	"capnproto ClickHouse/capnproto e7261205a6bea770d98e33ac94a35c2cd29e5b19"
	"cassandra ClickHouse/cpp-driver f4a31e92a25c34c02c7291ff97c7813bc83b0e09"
	"cctz ClickHouse/cctz c2ba12b73531a7dbc3ac45b5007649e35760f6d8"
	"chdig azat/chdig 9302521212c898fa7d91df827136e74f3a760bb7"
	"cld2 ClickHouse/cld2 b19c9d5bee6622c1b1efd33264ccca6a76fb0430"
	"clickstack ClickHouse/clickhouse-clickstack f5232dc36db0f151c6a19a770710fbeebfd9051b"
	"corrosion corrosion-rs/corrosion c4840742d23d1c1a187152e2c5ae65886b9c9007"
	"cppkafka ClickHouse/cppkafka 8cc2f31027664e33b5df058f917275c1e9a84a30"
	"crc32-s390x linux-on-ibm-z/crc32-s390x 30980583bf9ed3fa193abb83a1849705ff457f70"
	"crc32-vpmsum antonblanchard/crc32-vpmsum 452155439389311fc7d143621eaf56a258e02476"
	"crc32c ClickHouse/crc32c 8e39af2c7f8b23d1a0c2a6367b3313149c20b520"
	"croaring RoaringBitmap/CRoaring 025ae3f7add169bc820dcfd46fa9304f382ec40a"
	"cyrus-sasl ClickHouse/cyrus-sasl e6466edfd638cc5073debe941c53345b18a09512"
	"darts-clone s-yata/darts-clone 87b71afd6cf784953e3c08f24c64203397f3b724"
	"datasketches-cpp apache/datasketches-cpp 76edd74f5db286b672c170a8ded4ce39b3a8800f"
	"delta-kernel-rs ClickHouse/delta-kernel-rs 88ff5a947478215d285783b42aafe6f3d04aca58"
	"double-conversion ClickHouse/double-conversion 4f7a25d8ced8c7cf6eee6fd09d6788eaa23c9afe"
	"fast_float fastfloat/fast_float 34164f547b7df3f5d794ff67e9f885c36819ebfc"
	"fastops ClickHouse/fastops e2fbb015ae99e031eaf0223cd2d5d09ca63cfedb"
	"flatbuffers ClickHouse/flatbuffers 0bed8cd4a001850de9591563df99b435349ba05e"
	"fmtlib ClickHouse/fmt 4d9c4a8580235ba0b22fc6dbf70bcd29eb3ca84c"
	"google-benchmark google/benchmark 2257fa4d6afb8e5a2ccd510a70f38fe7fcdf1edf"
	"google-cloud-cpp ClickHouse/google-cloud-cpp 499787a71646ee5f7d9a845aee79a1b0663c947d"
	"google-protobuf protocolbuffers/protobuf 35cd01f9fe9afbeea38cc7b979a3b6bfcde82c03"
	"googletest google/googletest 35d0c365609296fa4730d62057c487e3cfa030ff"
	"grpc ClickHouse/grpc a703d1f9448ff77deca3beb36dfc7d337a209d3e"
	"h3 ClickHouse/h3 e38f58ef051280ebdd628d275a12cb667e8c4a3c"
	"hive-metastore ClickHouse/hive-metastore 809a77d435ce218d9b000733f19489c606fc567b"
	"icudata ClickHouse/icudata e3ae5bcb2b24f17cd9336c4f1b25f36ed636d839"
	"icu ClickHouse/icu b29faa6d4e46f10d230b93a3c33885e7ec71bd41"
	"idna ada-url/idna 3c8be01d42b75649f1ac9b697d0ef757eebfe667"
	"isa-l ClickHouse/isa-l 9f2b68f05752097f0f16632fc4a9a86950831efd"
	"jemalloc ClickHouse/jemalloc e6cea775d316273b05581f6a7c3609be649eb754"
	"jwt-cpp Thalhammer/jwt-cpp b0ea29a58fc852a67d4e896d266880c2c63b0c4c"
	"krb5 ClickHouse/krb5 857c2d1edd7a4218b84594768587aa53fd63da9e"
	"lemmagen-c ClickHouse/lemmagen-c 59537bdcf57bbed17913292cb4502d15657231f1"
	"libarchive libarchive/libarchive 27cbc7827172698143e440801fc0ba39ccb4f1f5"
	"libbcrypt rg3/libbcrypt 8aa32ad94ebe06b76853b0767c910c9fbf7ccef4"
	"libcotp paolostivanin/libcotp 3a7fa1a780716534e800ba51f80fe929af77adf7"
	"libcpuid anrieff/libcpuid 3c5b94bea740badb8da703e4a30a0ef70d956010"
	"libdeflate ClickHouse/libdeflate ec0718b8e06dc172eb87ede6a493865ccf7610ec"
	"libdivide ridiculousfish/libdivide 01526031eb79375dc85e0212c966d2c514a01234"
	"libfiu ClickHouse/libfiu 74bc382193df83d829f9e5b99d7f17a841c5cf74"
	"libgsasl ClickHouse/libgsasl 2d16b4e0d9435bec4546875ef07d36383bb993a5"
	"libhdfs3 ClickHouse/libhdfs3 ceb428c52e6b4362a35ec18b69206d9bb94edce3"
	"libpqxx ClickHouse/libpqxx 24a31c3f3a9317131b1326c7b87f42053a5f4489"
	"libprotobuf-mutator google/libprotobuf-mutator dc4ced337a9fb4047e2dc727268fbac55ca82f73"
	"librdkafka ClickHouse/librdkafka a0f91df2d9eb989829ddc5d5358da48342b41d48"
	"librseq compudj/librseq 2ca6d3775a750b180b5c82b999aa5b46f3fea1a7"
	"libssh ClickHouse/libssh 50313883f3a077458cde4ea95bf46bfeb0771b34"
	"libstemmer_c ClickHouse/libstemmer_c e138ee768ef8935d1957769e73850ca8c795efde"
	"libucontext kaniini/libucontext 3a5a20858e6f79d11f44cba31c3545731362ad73"
	"liburing axboe/liburing e3d35ea59d3ba09075ed4d7751e4bb9049cce64a"
	"libuv ClickHouse/libuv 714b58b9849568211ade86b44dd91d37f8a2175e"
	"libxml2 GNOME/libxml2 c94eb0210183b9d7cb43f8e7fddc6be55843ef49"
	"llvm-project ClickHouse/llvm-project c7f5fc7904a38ed3d1f6999fc615ad666905d1df"
	"lz4 lz4/lz4 ebb370ca83af193212df4dcbadcc5d87bc0de2f0"
	"magic_enum Neargye/magic_enum 1a1824df7ac798177a521eed952720681b0bf482"
	"mapbox-geometry ClickHouse/geometry.hpp 12ac5412bf85571852ad1cd7c30456faef8d6464"
	"mariadb-connector-c ClickHouse/mariadb-connector-c 111ec1a5958cf984f50a28b0fb82a4087918d677"
	"miniselect danlark1/miniselect be0af6bd0b6eb044d1acc4f754b229972d99903a"
	"minizip-ng zlib-ng/minizip-ng 95ba7abdd24a956bde584db54d1d55e37d511e2f"
	"mongo-c-driver ClickHouse/mongo-c-driver 6b6b676bdbd46fdb954ed1535893020ef91cce5b"
	"mongo-cxx-driver mongodb/mongo-cxx-driver 9b0c13260590bb6485fa57c20f61098870b99ab6"
	"morton-nd morton-nd/morton-nd 3795491a4aa3cdc916c8583094683f0d68df5bc0"
	"msgpack-c ClickHouse/msgpack-c 6b0d778ae059cfb77e26f2a011e99b17a8563c23"
	"musl ClickHouse/musl 7f52b7a53a0e830dbfbf1ebf9381048aed968185"
	"nats-io ClickHouse/nats.c cf441828d30fdd5de12d9da319e88d2586fdeeba"
	"nlohmann-json nlohmann/json 55f93686c01528224f448c19128836e7df245f72"
	"nlp-data ClickHouse/nlp-data 5591f91f5e748cba8fb9ef81564176feae774853"
	"numactl ClickHouse/numactl ff32c618d63ca7ac48cce366c5a04bb3563683a0"
	"openldap openldap/openldap 22fe35c6b4098e3ad166469f9574c79832c42952"
	"openssl ClickHouse/openssl 26868a38972e80dd15f56212c3677d77363f5c74"
	"orc ClickHouse/orc 6a2fe65eb16ce4c760964dca619260226c1b418e"
	"pocketfft mreineck/pocketfft f4c1aa8aa9ce79ad39e80f2c9c41b92ead90fda3"
	"postgres ClickHouse/postgres ab6952af3ac8cdede654be4dc68f990b0352c213"
	"rapidjson ClickHouse/rapidjson 04dc6714905247b4529310e0cf73a03a3b8148df"
	"re2 ClickHouse/re2 1f24555c97150767d65aa77fde8ddd029d2bb97c"
	"replxx ClickHouse/replxx c2de583a3cd41f7b476cb625e954c191b6fcc448"
	"rocksdb facebook/rocksdb d250fae809fe6af931d12a857d07e6f2b96e1c11"
	"rust_vendor ClickHouse/rust_vendor 8f91308de3d1b78a1fc3256a2e64bd91744c3a11"
	"s2geometry ClickHouse/s2geometry 5409e159ec6e0334022395ed33ed24e60c69b6ae"
	"silk ClickHouse/silk 78aab9d603d43247fa8f05f86c34ecdfe2ab4095"
	"simdcomp fast-pack/simdcomp 009c67807670d16f8984c0534aef0e630e5465a4"
	"simdjson ClickHouse/simdjson e95c118160780c2b808d86953938ce40b445d764"
	"simdutf ClickHouse/simdutf ea20f7cbc39fa29a761a443cbccd9668c0b48287"
	"snappy ClickHouse/snappy 052d3e8ddb00003e7288ef5c3bb47806196879e5"
	"sparsehash-c11 sparsehash/sparsehash-c11 cf0bffaa456f23bc4174462a789b90f8b6f5f42f"
	"spdlog gabime/spdlog 486b55554f11c9cccc913e11a87085b2a91f706f"
	"sqids-cpp sqids/sqids-cpp a471f53672e98d49223f598528a533b07b085c61"
	"sqlite-amalgamation ClickHouse/sqlite-amalgamation 23c7b76929611997c5f0315b3149372b1bee1d41"
	"sysroot ClickHouse/sysroot caf9c9f560e5a06295d961860ed717fe169e8cef"
	"sz3 ClickHouse/SZ3 f36e8b064fdde4bac260988ea459786964bbb492"
	"thrift ClickHouse/thrift 13d30d6a6cdfbd44c07977b8b762e88d9d5eb6df"
	"ulid-c ClickHouse/ulid-c c433b6783cf918b8f996dacd014cb2b68c7de419"
	"usearch ClickHouse/usearch 1ae009a6aa573629c8871ddb97dd6e1a9c03dd5f"
	"vectorscan ClickHouse/vectorscan e6993b7003a19806902fa69ac57dcc2df826b946"
	"wagyu ClickHouse/wagyu 22ce25812c98e42dc277805941ab8e6577ba729b"
	"wasmedge WasmEdge/WasmEdge fba982bd1ab4b1ea95308ff77044f3779fd6be6e"
	"wasmtime ClickHouse/wasmtime 561b224fd0589a02fc9e7bcef1aeb70d886d33c0"
	"wordnet-blast ClickHouse/wordnet-blast 1d16ac28036e19fe8da7ba72c16a307fbdf8c87e"
	"wyhash wangyi-fudan/wyhash 991aa3dab624e50b066f7a02ccc9f6935cc740ec"
	"xsimd ClickHouse/xsimd f795779ccfad12832ea47bfc02d02a65fd7f3576"
	"xxHash Cyan4973/xxHash bbb27a5efb85b92a0486cf361a8635715a53f6ba"
	"xz tukaani-project/xz 4b73f2ec19a99ef465282fbce633e8deb33691b3"
	"yaml-cpp ClickHouse/yaml-cpp acf418672e8aae00fa0de9ada9753e9001a6d57e"
	"zlib-ng ClickHouse/zlib-ng a2fbeffdc30a8b0ce6d54ee31208e2688eac4c9f"
	"zmij vitaut/zmij b490231ab0cd976b8e3a6e3b442c7eeee22fe05d"
	"zstd ClickHouse/zstd 5b3e9e8fd2779260101a07e6cc7b34fd8764617f"
	"zxc ClickHouse/zxc b9890cfe3466b19d0eb5005874ce81728efb9565"
)

SRC_URI="https://github.com/ClickHouse/ClickHouse/archive/v${PV}-lts.tar.gz -> ${P}.tar.gz"
for submodule in "${CH_SUBMODULES[@]}"; do
	parts=( ${submodule} )
	SRC_URI+=" https://github.com/${parts[1]}/archive/${parts[2]}.tar.gz -> ${P}-${parts[0]}.gh.tar.gz"
done
unset submodule parts

S="${WORKDIR}/ClickHouse-${PV}-lts"
LICENSE="0BSD Apache-2.0 BSD BSD-2 BZIP2 Boost-1.0 CC0-1.0 CDLA-Permissive-2.0 GPL-2 ISC LGPL-2.1+ MIT MIT-0 MPL-2.0 OPENLDAP POSTGRESQL Unicode-3.0 Unlicense UoI-NCSA ZLIB openssl public-domain"
SLOT="0"
KEYWORDS="~amd64"
# upstream unit tests hang in the sandbox (network-dependent)
RESTRICT="test"

RDEPEND="
	acct-group/clickhouse
	acct-user/clickhouse
"
BDEPEND="
	acct-group/clickhouse
	acct-user/clickhouse
	$(llvm_gen_dep '
		llvm-core/clang:${LLVM_SLOT}
		llvm-core/lld:${LLVM_SLOT}
	')
	dev-lang/nasm
	dev-lang/yasm
"

src_prepare() {
	local f=contrib/liburing-cmake/CMakeLists.txt
	grep -q 'LIBURING_CONFIG_HAS_OPEN_HOW.*FALSE' "${f}" || die "liburing open_how patch target changed"
	sed -i '/LIBURING_CONFIG_HAS_OPEN_HOW/s/FALSE/TRUE/' "${f}" || die
	cmake_src_prepare
}

src_unpack() {
	default
	local submodule parts name repo sha
	for submodule in "${CH_SUBMODULES[@]}"; do
		parts=( ${submodule} )
		name=${parts[0]} repo=${parts[1]##*/} sha=${parts[2]}
		[[ -d ${WORKDIR}/${repo}-${sha} ]] || die "missing submodule ${repo}-${sha} for contrib/${name}"
		rm -rf "${S}/contrib/${name}" || die
		mv "${WORKDIR}/${repo}-${sha}" "${S}/contrib/${name}" || die "relocate contrib/${name}"
	done
}

src_configure() {
	local llvm_bin="$(get_llvm_prefix -b)/bin"
	export CC="${llvm_bin}/clang" CXX="${llvm_bin}/clang++"
	unset CFLAGS CXXFLAGS LDFLAGS

	local compiler_cache=disabled
	has ccache ${FEATURES} && compiler_cache=ccache

	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=OFF
		-DWERROR=OFF
		-DENABLE_RUST=OFF
		-DCOMPILER_CACHE=${compiler_cache}
		-DENABLE_TESTS=OFF
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	newinitd "${FILESDIR}"/clickhouse.initd-r1 clickhouse
	newconfd "${FILESDIR}"/clickhouse.confd-r1 clickhouse
	systemd_newunit "${FILESDIR}"/clickhouse.service-r1 clickhouse.service
	newtmpfiles "${FILESDIR}"/clickhouse.tmpfiles-r1 clickhouse.conf

	sed -i 's|/var/log/clickhouse-server|/var/log/clickhouse|g' \
		"${ED}"/etc/clickhouse-server/config.xml || die

	diropts -m0750 -o clickhouse -g clickhouse
	keepdir /var/lib/clickhouse /var/log/clickhouse
}

pkg_postinst() {
	tmpfiles_process clickhouse.conf
}
