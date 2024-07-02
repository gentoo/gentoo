# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_IN_SOURCE_BUILD=1
PYTHON_COMPAT=( python3_{10,12} )
inherit cmake flag-o-matic python-any-r1

MY_PV="${PV//_pre/-pre}"

DESCRIPTION="Modern open source high performance RPC framework"
HOMEPAGE="https://www.grpc.io"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/${PN}-${MY_PV}"
LICENSE="Apache-2.0"
# format is 0/${CORE_SOVERSION//./}.${CPP_SOVERSION//./} , check top level CMakeLists.txt
SLOT="0/39.162"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="doc examples test systemd"
RESTRICT="!test? ( test )"

# look for submodule versions in third_party dir
RDEPEND="
	=dev-cpp/abseil-cpp-20230802.0*:=
	>=dev-libs/re2-0.2021.11.01:=
	>=dev-libs/openssl-1.1.1:0=[-bindist(-)]
	>=dev-libs/protobuf-23.3:=
	dev-libs/xxhash
	>=net-dns/c-ares-1.15.0:=
	sys-libs/zlib:=
	systemd? ( sys-apps/systemd:= )
"
DEPEND="
	${RDEPEND}
	test? (
		dev-cpp/benchmark
		dev-cpp/gflags
		dev-cpp/gtest
	)
"
BDEPEND="
	${RDEPEND}
	virtual/pkgconfig
	test? (
		net-misc/curl
		$(python_gen_any_dep '
			dev-python/twisted[${PYTHON_USEDEP}]
			dev-python/pyyaml[${PYTHON_USEDEP}]
			dev-python/cffi[${PYTHON_USEDEP}]
			dev-python/six[${PYTHON_USEDEP}]
		')
	)
"

PATCHES=( "${FILESDIR}/${PN}-1.62.1-system-gtest.patch" )

python_check_deps() {
	python_has_version -b "dev-python/twisted[${PYTHON_USEDEP}]" &&
	python_has_version -b "dev-python/pyyaml[${PYTHON_USEDEP}]" &&
	python_has_version -b "dev-python/cffi[${PYTHON_USEDEP}]" &&
	python_has_version -b "dev-python/six[${PYTHON_USEDEP}]"
}

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

soversion_check() {
	local core_sover cpp_sover
	# extract quoted number. line we check looks like this: 'set(gRPC_CPP_SOVERSION    "1.37")'
	core_sover="$(grep 'set(gRPC_CORE_SOVERSION ' CMakeLists.txt  | sed '/.*\"\(.*\)\".*/ s//\1/')"
	cpp_sover="$(grep 'set(gRPC_CPP_SOVERSION ' CMakeLists.txt  | sed '/.*\"\(.*\)\".*/ s//\1/')"
	# remove dots, e.g. 1.37 -> 137
	core_sover="${core_sover//./}"
	cpp_sover="${cpp_sover//./}"
	[[ ${core_sover} -eq $(ver_cut 2 ${SLOT}) ]] || die "fix core sublot! should be ${core_sover}"
	[[ ${cpp_sover} -eq $(ver_cut 3 ${SLOT}) ]] || die "fix cpp sublot! should be ${cpp_sover}"
}

src_prepare() {
	# These extra libs are defined as dependencies of the vendored gtest,
	# which is a dependency of the unit tests, therefore they are normally
	# implicitly picked up and linked to the test binaries.  However removing
	# the vendored gtest to use the system one also removes these dependencies,
	# so we have to redeclare them as dependencies of the test binaries individually.
	local extra_libs=("gtest"
					"gmock"
					"\${_gRPC_RE2_LIBRARIES}"
					"absl::flat_hash_set"
					"absl::failure_signal_handler"
					"absl::stacktrace"
					"absl::symbolize"
					"absl::flags"
					"absl::flags_parse"
					"absl::flags_reflection"
					"absl::flags_usage"
					"absl::strings"
					"absl::any"
					"absl::optional"
					"absl::variant")
	: "$(echo "${extra_libs[@]}" | "${EPYTHON}" -c 'import sys;print("\\n\\1".join(sys.stdin.read().split()))')"
	local rstring="${_}"
	sed -i -E "s/( +)gtest/\1${rstring}/g" "CMakeLists.txt" || die

	# Integrate tests with ctest rather than the custom test framework.
	# Formatted with dev-python/black.
	"${EPYTHON}" - <<-EOF | tee -a "CMakeLists.txt"
		import json, pathlib

		print("if(gRPC_BUILD_TESTS)")
		print("  ENABLE_TESTING()")
		for line in [
		  json.dumps([t["name"], "./" + t["name"], *t["args"]]).translate(
		  str.maketrans(dict.fromkeys("[],", None))
		  )
		  for t in json.loads(
		    pathlib.Path("tools/run_tests/generated/tests.json").read_text()
		  )
		  if "linux" in t["platforms"] and not t["flaky"] and not t.get("boringssl", False)
		]:
		  print(f"  add_test({line})")
		print("endif()")
	EOF

	# Weird path issue.  All tests except these two assume they are running from top-level src
	sed -i -E "s/lslash != nullptr/false/" "test/core/http/httpcli_test_util.cc" || die

	# Called via system() by some of the C++ sources, respect EPYTHON
	sed -i -E "s#for p in #for p in \"${EPYTHON}\"#" "tools/distrib/python_wrapper.sh" || die

	# Respect EPYTHON when testing, don't touch installed files otherwise
	use test && python_fix_shebang --force "${S}"

	cmake_src_prepare

	# un-hardcode libdir
	sed -i "s@/lib@/$(get_libdir)@" cmake/pkg-config-template.pc.in || die

	# suppress network access, package builds fine without the submodules
	mkdir "${S}/third_party/opencensus-proto/src" || die

	soversion_check
}

src_configure() {
	# https://github.com/grpc/grpc/issues/29652
	filter-lto

	local mycmakeargs=(
		-DgRPC_INSTALL=ON
		-DgRPC_ABSL_PROVIDER=package
		-DgRPC_CARES_PROVIDER=package
		-DgRPC_INSTALL_CMAKEDIR="$(get_libdir)/cmake/${PN}"
		-DgRPC_INSTALL_LIBDIR="$(get_libdir)"
		-DgRPC_PROTOBUF_PROVIDER=package
		-DgRPC_RE2_PROVIDER=package
		-DgRPC_SSL_PROVIDER=package
		-DgRPC_ZLIB_PROVIDER=package
		-DgRPC_BUILD_TESTS=$(usex test)
		-DCMAKE_CXX_STANDARD=17
		-DCMAKE_DISABLE_FIND_PACKAGE_systemd=$(usex !systemd)
		$(usex test '-DgRPC_BENCHMARK_PROVIDER=package' '')
	)
	cmake_src_configure
}

src_test() {
	# This is normally done with start_port_server.py, but this forks and exits,
	# while we need to capture the pid, so run it ourselves
	"${EPYTHON}" "tools/run_tests/python_utils/port_server.py" \
		-p 32766 -l "${T}/port_server.log" &
	local port_server_pid="${!}"

	# Reimplementation of what start_port_server.py does with curl
	curl --retry 9999 --retry-all-errors --retry-max-time 120 \
		--fail --silent --output /dev/null "http://localhost:32766/get" || die

	local disabled_tests=(
		no_logging_test # hangs everywhere, no output
		grpc_tool_test # fails everywhere
		examine_stack_test # fails on amd64 only
		stack_tracer_test # fails on amd64 only
		endpoint_pair_test # fails on alpha
		event_poller_posix_test # fails on alpha
		tcp_posix_test # fails on alpha
	)

	cmake_src_test -E "($(IFS=$"|"; echo "${disabled_tests[*]}"))"

	kill "${port_server_pid}" || die
}

src_install() {
	cmake_src_install

	if use examples; then
		find examples -name '.gitignore' -delete || die
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi

	if use doc; then
		find doc -name '.gitignore' -delete || die
		local DOCS=( AUTHORS CONCEPTS.md README.md TROUBLESHOOTING.md doc/. )
	fi

	einstalldocs
}
