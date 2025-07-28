# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Keep an eye on both of these after releases for patches:
# * https://www.boost.org/patches/
# * https://www.boost.org/users/history/version_${MY_PV}.html
# (e.g. https://www.boost.org/users/history/version_1_83_0.html)
# Note that the latter may sometimes feature patches not on the former too.

PYTHON_COMPAT=( python3_{11..13} )

inherit dot-a edo flag-o-matic multiprocessing python-r1 toolchain-funcs multilib-minimal

MY_PV="$(ver_rs 1- _)"

DESCRIPTION="Boost Libraries for C++"
HOMEPAGE="https://www.boost.org/"
SRC_URI="https://archives.boost.io/release/${PV}/source/boost_${MY_PV}.tar.bz2"
S="${WORKDIR}/${PN}_${MY_PV}"

LICENSE="Boost-1.0"
SLOT="0/${PV}"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="bzip2 +context debug doc icu lzma +nls mpi numpy python +stacktrace test test-full tools zlib zstd"
REQUIRED_USE="
	python? ( ${PYTHON_REQUIRED_USE} )
	test-full? ( test )
"
RESTRICT="!test? ( test )"

RDEPEND="
	bzip2? ( app-arch/bzip2:=[${MULTILIB_USEDEP}] )
	icu? ( dev-libs/icu:=[${MULTILIB_USEDEP}] )
	!icu? ( virtual/libiconv[${MULTILIB_USEDEP}] )
	lzma? ( app-arch/xz-utils:=[${MULTILIB_USEDEP}] )
	mpi? ( virtual/mpi[${MULTILIB_USEDEP},cxx,threads] )
	python? (
		${PYTHON_DEPS}
		numpy? ( dev-python/numpy:=[${PYTHON_USEDEP}] )
	)
	zlib? ( sys-libs/zlib:=[${MULTILIB_USEDEP}] )
	zstd? ( app-arch/zstd:=[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}"
BDEPEND=">=dev-build/b2-5.1.0"

PATCHES=(
	"${FILESDIR}"/${PN}-1.88.0-disable_icu_rpath.patch
	"${FILESDIR}"/${PN}-1.88.0-build-auto_index-tool.patch
	"${FILESDIR}"/${PN}-1.88.0-process-error-alpha.patch
	"${FILESDIR}"/${PN}-1.88.0-algorithm-reverse_copy.patch
	"${FILESDIR}"/${PN}-1.88.0-beast-network-sandbox.patch
	"${FILESDIR}"/${PN}-1.88.0-bind-no-Werror.patch
	"${FILESDIR}"/${PN}-1.88.0-mysql-cstdint.patch
	"${FILESDIR}"/${PN}-1.88.0-range-any_iterator.patch
	"${FILESDIR}"/${PN}-1.88.0-system-crashing-test.patch
	"${FILESDIR}"/${PN}-1.88.0-yap-cstdint.patch
)

create_user-config.jam() {
	local user_config_jam="${BUILD_DIR}"/user-config.jam
	if [[ -s ${user_config_jam} ]]; then
		einfo "${user_config_jam} already exists, skipping configuration"
		return
	else
		einfo "Creating configuration in ${user_config_jam}"
	fi

	local compiler compiler_version compiler_executable="$(tc-getCXX)"
	compiler="gcc"
	compiler_version="$(gcc-version)"

	if use mpi; then
		local mpi_configuration="using mpi ;"
	fi

	cat > "${user_config_jam}" <<- __EOF__ || die
		using ${compiler} : ${compiler_version} : ${compiler_executable} : <cflags>"${CPPFLAGS} ${CFLAGS}" <cxxflags>"${CPPFLAGS} ${CXXFLAGS}" <linkflags>"${LDFLAGS}" <archiver>"$(tc-getAR)" <ranlib>"$(tc-getRANLIB)" ;
		${mpi_configuration}
	__EOF__

	if multilib_native_use python; then
		append_to_user_config() {
			local py_config
			if tc-is-cross-compiler; then
				py_config="using python : ${EPYTHON#python} : : ${ESYSROOT}/usr/include/${EPYTHON} : ${ESYSROOT}/usr/$(get_libdir) ;"
			else
				py_config="using python : ${EPYTHON#python} : ${PYTHON} : $(python_get_includedir) ;"
			fi
			echo "${py_config}" >> "${user_config_jam}" || die
		}
		python_foreach_impl append_to_user_config
	fi

	if multilib_native_use python && use numpy; then
		einfo "Enabling support for NumPy extensions in Boost.Python"
	else
		einfo "Disabling support for NumPy extensions in Boost.Python"

		# Boost.Build does not allow for disabling of numpy
		# extensions, thereby leading to automagic numpy
		# https://github.com/boostorg/python/issues/111#issuecomment-280447482
		sed \
			-e 's/\[ unless \[ python\.numpy \] : <build>no \]/<build>no/g' \
			-i "${BUILD_DIR}"/libs/python/build/Jamfile || die
	fi
}

pkg_setup() {
	# Bail out on unsupported build configuration, bug #456792
	if [[ -f "${EROOT}"/etc/site-config.jam ]]; then
		if ! grep -q 'gentoo\(debug\|release\)' "${EROOT}"/etc/site-config.jam; then
			eerror "You are using custom ${EROOT}/etc/site-config.jam without defined gentoorelease/gentoodebug targets."
			eerror "Boost can not be built in such configuration."
			eerror "Please, either remove this file or add targets from ${EROOT}/usr/share/boost-build/site-config.jam to it."
			die "Unsupported target in ${EROOT}/etc/site-config.jam"
		fi
	fi
}

src_prepare() {
	default
	multilib_copy_sources
}

ejam() {
	create_user-config.jam

	local b2_opts=( "--user-config=${BUILD_DIR}/user-config.jam" )
	if multilib_native_use python; then
		append_to_b2_opts() {
			b2_opts+=( python="${EPYTHON#python}" )
		}
		python_foreach_impl append_to_b2_opts
	else
		b2_opts+=( --without-python )
	fi
	b2_opts+=( "$@" )

	echo b2 "${b2_opts[@]}" >&2
	b2 "${b2_opts[@]}"
}

src_configure() {
	# -Werror=odr
	# https://bugs.gentoo.org/943975
	# https://github.com/boostorg/quickbook/issues/27
	# https://github.com/boostorg/spirit/issues/800
	use tools && filter-lto

	lto-guarantee-fat

	# Workaround for too many parallel processes requested, bug #506064
	[[ "$(makeopts_jobs)" -gt 64 ]] && MAKEOPTS="${MAKEOPTS} -j64"

	# We don't want to end up with -L/usr/lib on our linker lines
	# which then gives us lots of
	#   skipping incompatible /usr/lib/libc.a when searching for -lc
	# warnings
	[[ -n ${ESYSROOT} ]] && local icuarg="-sICU_PATH=${ESYSROOT}/usr"

	OPTIONS=(
		$(usex debug gentoodebug gentoorelease)
		"-j$(makeopts_jobs)"
		-q
		-d+2
		pch=off
		$(usex icu "${icuarg}" '--disable-icu boost.locale.icu=off')
		$(usev !mpi --without-mpi)
		$(usev !nls --without-locale)
		$(usev !context '--without-context --without-coroutine --without-fiber')
		$(usev !stacktrace --without-stacktrace)
		--boost-build="${BROOT}"/usr/share/b2/src
		--layout=system
		# building with threading=single is currently not possible
		# https://svn.boost.org/trac/boost/ticket/7105
		threading=multi
		link=shared
		# this seems to be the only way to disable compression algorithms
		# https://www.boost.org/doc/libs/1_70_0/libs/iostreams/doc/installation.html#boost-build
		-sNO_BZIP2=$(usex bzip2 0 1)
		-sNO_LZMA=$(usex lzma 0 1)
		-sNO_ZLIB=$(usex zlib 0 1)
		-sNO_ZSTD=$(usex zstd 0 1)
		boost.stacktrace.from_exception=off
	)

	if [[ ${CHOST} == *-darwin* ]]; then
		# We need to add the prefix, and in two cases this exceeds, so prepare
		# for the largest possible space allocation.
		append-ldflags -Wl,-headerpad_max_install_names
	fi

	# Use C++17 globally as of 1.80
	append-cxxflags -std=c++17

	if [[ ${CHOST} != *-darwin* ]]; then
		# On modern macOS, file I/O is already 64-bit by default,
		# there's no support for special options like O_LARGEFILE.
		# Thus, LFS must be disabled.
		#
		# On other systems, we need to enable LFS explicitly for 64-bit
		# offsets on 32-bit hosts (#894564)
		append-lfs-flags
	fi
}

multilib_src_compile() {
	ejam \
		--prefix="${EPREFIX}"/usr \
		"${OPTIONS[@]}" || die

	if multilib_native_use tools; then
		pushd tools >/dev/null || die
		ejam \
			--prefix="${EPREFIX}"/usr \
			"${OPTIONS[@]}" \
			|| die "Building of Boost tools failed"
		popd >/dev/null || die
	fi
}

multilib_src_test() {
	##
	## Preparation
	##

	# Some test suites have no main because normally boost.test can
	# automatically initialize & run them, but this only seems to be
	# supported for statically linked builds/tests.
	# Therefore we use an explicit list of tests which need patching
	# with an additional main().
	# Determining this dynamically is not really possible.
	local libs_needpatch=(
		"accumulators"
	)

	einfo "Patching: ${libs_needpatch[@]}"

	local lib
	for lib in "${libs_needpatch[@]}"; do
		# move into library test dir
		pushd "${BUILD_DIR}/libs/${lib}/test" >/dev/null || die
			# find all test cases and patch them
			local testcases testcase
			readarray -td '' testcases < <(find . -name "*.cpp" -print0)
			for testcase in "${testcases[@]}"; do
				# add main() to bootstrap old-style test suite
				cat "${FILESDIR}/unit-test-main.cpp" >> ${testcase} || die
			done
		popd >/dev/null
	done

	##
	## Test exclusions
	##

	# The following libraries do not compile or fail their tests:
	local libs_excluded=(
		# is_invocable.cpp:35:58: error: static assertion failed: (std::is_invocable<Callable, Args...>() == boost::callable_traits::is_invocable<Callable, Args...>())
		"callable_traits"
		# test output comparison failure
		"config"
		# "C++03 support was deprecated in Boost.Chrono 1.82" ??
		"contract"
		# undefined reference to `boost::math::concepts::real_concept boost::math::bernoulli_b2n<boost::math::concepts::real_concept>(int)
		"math"
		# assignment of read-only member 'gauss::laguerre::detail::laguerre_l_object<T>::order'
		"multiprecision"
		# PyObject* boost::parameter::python::aux::unspecified_type():
		#   /usr/include/python3.13/object.h:339:30: error: lvalue required as left operand of assignment
		"parameter_python"
		# scope/lambda_tests22.cpp(27): test 'x == 1' failed in function 'int main()'
		"phoenix"
		# Unable to find file or target named (yes, really)
		"predef"
		# AttributeError: property '<unnamed Boost.Python function>' of 'X' object has no setter
		"python"
		# vec_access.hpp:95:223: error: static assertion failed: Boost QVM static assertion failure
		"qvm"
		# regex_timer.cpp:19: ../../../boost/timer.hpp:21:3: error: #error This header is
		#   deprecated and will be removed. (You can define BOOST_TIMER_ENABLE_DEPRECATED to suppress
		#   this error.)
		"regex"
		# in function `boost::archive::tmpnam(char*)': test_array.cpp:(.text+0x108):
		#   undefined reference to `boost::filesystem::detail::unique_path(...)'
		"serialization"
		# TuTestMain.cpp(22) fatal error: in "test_main_caller( argc_ argv )":
		#   std::runtime_error: Event was not consumed!
		"statechart"
		# erase_tests.cpp:(.text+0x44cce): undefined reference to
		#   tbb::detail::r1::execution_slot(tbb::detail::d1::execution_data const*)
		"unordered"
		# t_5_007.cpp(22): error: could not find include file: boost/version.hpp
		"wave"
	)

	if ! use mpi; then
		# graph_parallel tries to use MPI even with use=-mpi
		local no_mpi=( "mpi" "graph_parallel" )
		einfo "Disabling tests due to USE=-mpi: ${no_mpi[@]}"
		libs_excluded+=( ${no_mpi[@]} )
	fi

	if ! use test-full; then
		# passes its tests but takes a very long time to build
		local no_full=( "geometry" )
		einfo "Disabling expensive tests due to USE=-test-full: ${no_full[@]}"
		libs_excluded+=( ${no_full[@]} )
	fi

	einfo "Skipping the following tests: ${libs_excluded[@]}"

	##
	## Find and run tests
	##

	# Prepare to find libraries but without exclusions
	local excluded findlibs="find ${BUILD_DIR}/libs -maxdepth 1 -mindepth 1 -type d "
	for excluded in ${libs_excluded[@]}; do
	   findlibs+="-not -name ${excluded} "
	done

	# Must come as last argument
	findlibs+="-print0"

	# Collect libraries to test, with full path.
	# The list is then sorted to provide predictable execution order,
	# which would otherwise depend on the file system.
	local libs
	readarray -td '' libs < <(${findlibs})
	readarray -td '' libs < <(printf '%s\0' "${libs[@]}" | sort -z)

	# Build the list of test names we are about to run
	local lib_names
	for lib in ${libs[@]}; do
		lib_names+=("${lib##*/}")
	done

	# Create custom options for tests based on the build settings
	TEST_OPTIONS=("${OPTIONS[@]}")

	# Dial down log output - the full b2 command used to compile & run
	# a test suite will be printed by ejam and can be used to build
	# and run the tests in a test suite's directory.
	TEST_OPTIONS=("${TEST_OPTIONS[@]/-d+2/-d0}")

	# Finally build & run all test suites
	einfo "Running the following tests: ${lib_names[*]}"

	local failed_tests=()
	for lib in "${libs[@]}"; do
		# Skip libraries without test directory
		[[ ! -d "${lib}/test" ]] && continue

		# Move into library test dir & run all tests
		pushd "${lib}/test" >/dev/null || die
		nonfatal edob -m "Running tests in: $(pwd)" ejam --prefix="${EPREFIX}"/usr "${TEST_OPTIONS[@]}" || failed_tests+=( "${lib}" )
		popd >/dev/null || die
	done

	if (( ${#failed_tests[@]} )); then
		eerror "Failed tests. Printing summary."
		local failed_test
		for failed_test in "${failed_tests[@]}" ; do
			eerror "Failed test: ${failed_test}"
		done
		die "Tests failed."
	fi
}

multilib_src_install() {
	ejam \
		--prefix="${ED}"/usr \
		--includedir="${ED}"/usr/include \
		--libdir="${ED}"/usr/$(get_libdir) \
		"${OPTIONS[@]}" install || die "Installation of Boost libraries failed"

	if multilib_native_use tools; then
		dobin dist/bin/*

		insinto /usr/share
		doins -r dist/share/boostbook
	fi

	# boost's build system truely sucks for not having a destdir.  Because for
	# this reason we are forced to build with a prefix that includes the
	# DESTROOT, dynamic libraries on Darwin end messed up, referencing the
	# DESTROOT instread of the actual EPREFIX.  There is no way out of here
	# but to do it the dirty way of manually setting the right install_names.
	if [[ ${CHOST} == *-darwin* ]]; then
		einfo "Working around completely broken build-system(tm)"
		local d
		for d in "${ED}"/usr/lib/*.dylib; do
			if [[ -f ${d} ]]; then
				# fix the "soname"
				ebegin "  correcting install_name of ${d#${ED}}"
				install_name_tool -id "/${d#${D}}" "${d}"
				eend $?
				# fix references to other libs
				# these paths look like this:
				# bin.v2/libs/thread/build/gcc-12.1/gentoorelease/pch-off/
				#  threadapi-pthread/threading-multi/visibility-hidden/
				#  libboost_thread.dylib
				refs=$(otool -XL "${d}" | \
					sed -e '1d' -e 's/^\t//' | \
					grep "libboost_" | \
					cut -f1 -d' ')
				local r
				for r in ${refs}; do
					# strip path prefix from references, so we obtain
					# something like libboost_thread.dylib.
					local r_basename=${r##*/}

					ebegin "    correcting reference to ${r_basename}"
					install_name_tool -change \
						"${r}" \
						"${EPREFIX}/usr/lib/${r_basename}" \
						"${d}"
					eend $?
				done
			fi
		done
	fi
}

multilib_src_install_all() {
	if ! use numpy; then
		rm -r "${ED}"/usr/include/boost/python/numpy* || die
	fi

	if use python; then
		if use mpi; then
			move_mpi_py_into_sitedir() {
				python_moduleinto boost

				python_domodule "${ED}"/usr/$(get_libdir)/boost-${EPYTHON}/mpi.so
				rm -r "${ED}"/usr/$(get_libdir)/boost-${EPYTHON} || die

				python_optimize
			}
			python_foreach_impl move_mpi_py_into_sitedir
		else
			rm -r "${ED}"/usr/include/boost/mpi/python* || die
		fi
	else
		rm -r "${ED}"/usr/include/boost/{python*,mpi/python*,parameter/aux_/python,parameter/python*} || die
	fi

	if ! use nls; then
		rm -r "${ED}"/usr/include/boost/locale || die
	fi

	if ! use context; then
		rm -r "${ED}"/usr/include/boost/context || die
		rm -r "${ED}"/usr/include/boost/coroutine{,2} || die
		rm "${ED}"/usr/include/boost/asio/spawn.hpp || die
	fi

	if use doc; then
		# find extraneous files that shouldn't be installed
		# as part of the documentation and remove them.
		find libs/*/* \( -iname 'test' -o -iname 'src' \) -exec rm -rf '{}' + || die
		find doc \( -name 'Jamfile.v2' -o -name 'build' -o -name '*.manifest' \) -exec rm -rf '{}' + || die
		find tools \( -name 'Jamfile.v2' -o -name 'src' -o -name '*.cpp' -o -name '*.hpp' \) -exec rm -rf '{}' + || die

		docinto html
		dodoc *.{htm,html,png,css}
		dodoc -r doc libs more tools

		# To avoid broken links
		dodoc LICENSE_1_0.txt

		dosym ../../../../include/boost /usr/share/doc/${PF}/html/boost
	fi

	strip-lto-bytecode
}

pkg_preinst() {
	# Yay for having symlinks that are nigh-impossible to remove without
	# resorting to dirty hacks like these. Removes lingering symlinks
	# from the slotted versions.
	local symlink
	for symlink in "${EROOT}"/usr/include/boost "${EROOT}"/usr/share/boostbook; do
		if [[ -L ${symlink} ]]; then
			rm -f "${symlink}" || die
		fi
	done

	# some ancient installs still have boost cruft lying around
	# for unknown reasons, causing havoc for reverse dependencies
	# Bug: 607734
	rm -rf "${EROOT}"/usr/include/boost-1_[3-5]? || die
}

pkg_postinst() {
	elog "Boost.Regex is *extremely* ABI sensitive. If you get errors such as"
	elog
	elog "  undefined reference to \`boost::re_detail_$(ver_cut 1)0$(ver_cut 2)00::cpp_regex_traits_implementation"
	elog "    <char>::transform_primary[abi:cxx11](char const*, char const*) const'"
	elog
	elog "Then you need to recompile Boost and all its reverse dependencies"
	elog "using the same toolchain. In general, *every* change of the C++ toolchain"
	elog "requires a complete rebuild of the Boost-dependent ecosystem."
	elog
	elog "See for instance https://bugs.gentoo.org/638138"
}
