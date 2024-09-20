# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_IN_SOURCE_BUILD=1
PYTHON_COMPAT=( python3_{10..12} )
inherit cmake flag-o-matic python-any-r1

MY_PV="${PV//_pre/-pre}"

DESCRIPTION="Modern open source high performance RPC framework"
HOMEPAGE="https://www.grpc.io"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/${PN}-${MY_PV}"
LICENSE="Apache-2.0"
# format is 0/${CORE_SOVERSION//./}.${CPP_SOVERSION//./} , check top level CMakeLists.txt
SLOT="0/42.165"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv x86"
IUSE="doc examples test systemd"
RESTRICT="!test? ( test )"

# look for submodule versions in third_party dir
RDEPEND="
	>=dev-cpp/abseil-cpp-20240116:=
	>=dev-libs/re2-0.2022.04.01:=
	>=dev-libs/openssl-1.1.1:0=[-bindist(-)]
	>=dev-libs/protobuf-27.0:=
	dev-libs/xxhash
	>=net-dns/c-ares-1.19.1:=
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

PATCHES=(
	"${FILESDIR}/${PN}-1.65.0-system-gtest.patch"
	"${FILESDIR}/${PN}-1.65.0-vlog.patch"
)

python_check_deps() {
	if use test; then
		python_has_version -b "dev-python/twisted[${PYTHON_USEDEP}]" &&
		python_has_version -b "dev-python/pyyaml[${PYTHON_USEDEP}]" &&
		python_has_version -b "dev-python/cffi[${PYTHON_USEDEP}]" &&
		python_has_version -b "dev-python/six[${PYTHON_USEDEP}]"
	fi
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
	local extra_libs=(
		"GTest::gtest"
		"GTest::gmock"
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
		"absl::variant"
	)
	: "$(echo "${extra_libs[@]}" | "${EPYTHON}" -c 'import sys;print("\\n\\1".join(sys.stdin.read().split()))')"
	local rstring="${_}"
	sed -i -E "s/( +)gtest/\1${rstring}/g" "CMakeLists.txt" || die

	# Integrate tests with ctest rather than the custom test framework.
	# Formatted with dev-python/black.
	"${EPYTHON}" - <<-EOF | tee -a "CMakeLists.txt"
		import json, pathlib

		print("if(gRPC_BUILD_TESTS)")
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
		-DgRPC_DOWNLOAD_ARCHIVES=OFF
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
		-DgRPC_USE_SYSTEMD=$(usex systemd ON OFF)
		-DCMAKE_CXX_STANDARD=17
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

	CMAKE_SKIP_TESTS=(
		# CallCommandWithTimeoutDeadlineSet has a timeout set to 5000.25 seconds
		^grpc_tool_test$

		# Need network access
		^posix_event_engine_native_dns_test$
		^posix_event_engine_test$
		^resolve_address_using_ares_resolver_test$
		^resolve_address_using_native_resolver_test$
	)

	use amd64 && CMAKE_SKIP_TESTS+=(
		^examine_stack_test$ # fails on amd64 only
		^stack_tracer_test$ # fails on amd64 only
	)

	use alpha && CMAKE_SKIP_TESTS+=(
		^endpoint_pair_test$ # fails on alpha
		^event_poller_posix_test$ # fails on alpha
		^tcp_posix_test$ # fails on alpha
	)

	# NOTE breaks with shared linking because the metric is twice initialised in a static function in a anonymous namespace
	# metrics.cc:49] Metric name grpc.lb.pick_first.disconnections has already been registered.
	# https://bugs.gentoo.org/935787 Leave the bug open until we fixed the underlying issue
	CMAKE_SKIP_TESTS+=(
		^bad_ping_test$
		^binary_metadata_test$
		^call_creds_test$
		^call_host_override_test$
		^cancel_after_accept_test$
		^cancel_after_client_done_test$
		^cancel_after_invoke_test$
		^cancel_after_round_trip_test$
		^cancel_before_invoke_test$
		^cancel_in_a_vacuum_test$
		^cancel_with_status_test$
		^client_streaming_test$
		^compressed_payload_test$
		^connectivity_test$
		^default_host_test$
		^disappearing_server_test$
		^empty_batch_test$
		^filter_causes_close_test$
		^filter_init_fails_test$
		^filter_test_test$
		^filtered_metadata_test$
		^graceful_server_shutdown_test$
		^grpc_authz_test$
		^high_initial_seqno_test$
		^hpack_size_test$
		^http2_stats_test$
		^invoke_large_request_test$
		^keepalive_timeout_test$
		^large_metadata_test$
		^max_concurrent_streams_test$
		^max_connection_age_test$
		^max_connection_idle_test$
		^max_message_length_test$
		^negative_deadline_test$
		^no_logging_test$
		^no_op_test$
		^payload_test$
		^ping_pong_streaming_test$
		^ping_test$
		^proxy_auth_test$
		^registered_call_test$
		^request_with_flags_test$
		^request_with_payload_test$
		^resource_quota_server_test$
		^retry_cancel_after_first_attempt_starts_test$
		^retry_cancel_during_delay_test$
		^retry_cancel_with_multiple_send_batches_test$
		^retry_cancellation_test$
		^retry_disabled_test$
		^retry_exceeds_buffer_size_in_delay_test$
		^retry_exceeds_buffer_size_in_initial_batch_test$
		^retry_exceeds_buffer_size_in_subsequent_batch_test$
		^retry_lb_drop_test$
		^retry_lb_fail_test$
		^retry_non_retriable_status_before_trailers_test$
		^retry_non_retriable_status_test$
		^retry_per_attempt_recv_timeout_on_last_attempt_test$
		^retry_per_attempt_recv_timeout_test$
		^retry_recv_initial_metadata_test$
		^retry_recv_message_replay_test$
		^retry_recv_message_test$
		^retry_recv_trailing_metadata_error_test$
		^retry_send_initial_metadata_refs_test$
		^retry_send_op_fails_test$
		^retry_send_recv_batch_test$
		^retry_server_pushback_delay_test$
		^retry_server_pushback_disabled_test$
		^retry_streaming_after_commit_test$
		^retry_streaming_succeeds_before_replay_finished_test$
		^retry_streaming_test$
		^retry_test$
		^retry_throttled_test$
		^retry_too_many_attempts_test$
		^retry_transparent_goaway_test$
		^retry_transparent_max_concurrent_streams_test$
		^retry_transparent_not_sent_on_wire_test$
		^retry_unref_before_finish_test$
		^retry_unref_before_recv_test$
		^server_finishes_request_test$
		^server_streaming_test$
		^shutdown_finishes_calls_test$
		^shutdown_finishes_tags_test$
		^simple_delayed_request_test$
		^simple_metadata_test$
		^simple_request_test$
		^streaming_error_response_test$
		^test_core_end2end_channelz_test$
		^thread_pool_test$
		^timeout_before_request_call_test$
		^trailing_metadata_test$
		^write_buffering_at_end_test$
		^write_buffering_test$
	)

	# BUG this should be nonfatal and we kill the server even when tests fail
	cmake_src_test

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
