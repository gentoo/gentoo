# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit flag-o-matic multiprocessing python-r1 toolchain-funcs multilib-minimal

MY_PV="$(ver_rs 1- _)"
MAJOR_V="$(ver_cut 1-2)"

DESCRIPTION="Boost Libraries for C++"
HOMEPAGE="https://www.boost.org/"
SRC_URI="https://dl.bintray.com/boostorg/release/${PV}/source/boost_${MY_PV}.tar.bz2"

LICENSE="Boost-1.0"
SLOT="0/${PV}" # ${PV} instead ${MAJOR_V} due to bug 486122
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris ~x86-winnt"
IUSE="bzip2 context debug doc icu lzma +nls mpi numpy python static-libs +threads tools zlib zstd"
REQUIRED_USE="
	mpi? ( threads )
	python? ( ${PYTHON_REQUIRED_USE} )"

# the tests will never fail because these are not intended as sanity
# tests at all. They are more a way for upstream to check their own code
# on new compilers. Since they would either be completely unreliable
# (failing for no good reason) or completely useless (never failing)
# there is no point in having them in the ebuild to begin with.
RESTRICT="test"

RDEPEND="
	!app-admin/eselect-boost
	!dev-libs/boost-numpy
	!<dev-libs/leatherman-1.12.0-r1
	bzip2? ( app-arch/bzip2:=[${MULTILIB_USEDEP}] )
	icu? ( >=dev-libs/icu-3.6:=[${MULTILIB_USEDEP}] )
	!icu? ( virtual/libiconv[${MULTILIB_USEDEP}] )
	lzma? ( app-arch/xz-utils:=[${MULTILIB_USEDEP}] )
	mpi? ( >=virtual/mpi-2.0-r4[${MULTILIB_USEDEP},cxx,threads] )
	python? (
		${PYTHON_DEPS}
		numpy? ( dev-python/numpy[${PYTHON_USEDEP}] )
	)
	zlib? ( sys-libs/zlib:=[${MULTILIB_USEDEP}] )
	zstd? ( app-arch/zstd:=[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}"
BDEPEND="=dev-util/boost-build-${MAJOR_V}*"

S="${WORKDIR}/${PN}_${MY_PV}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.71.0-disable_icu_rpath.patch
	"${FILESDIR}"/${PN}-1.71.0-context-x32.patch
	"${FILESDIR}"/${PN}-1.71.0-build-auto_index-tool.patch
	# Boost.MPI's __init__.py doesn't work on Py3
	"${FILESDIR}"/${PN}-1.73-boost-mpi-python-PEP-328.patch
	# Remove annoying #pragma message
	"${FILESDIR}"/${PN}-1.73-property-tree-include.patch
	"${FILESDIR}"/${PN}-1.74-CVE-2012-2677.patch
)

python_bindings_needed() {
	multilib_is_native_abi && use python
}

tools_needed() {
	multilib_is_native_abi && use tools
}

create_user-config.jam() {
	local user_config_jam="${BUILD_DIR}"/user-config.jam
	if [[ -s ${user_config_jam} ]]; then
		einfo "${user_config_jam} already exists, skipping configuration"
		return
	else
		einfo "Creating configuration in ${user_config_jam}"
	fi

	local compiler compiler_version compiler_executable="$(tc-getCXX)"
	if [[ ${CHOST} == *-darwin* ]]; then
		compiler="darwin"
		compiler_version="$(gcc-fullversion)"
	else
		compiler="gcc"
		compiler_version="$(gcc-version)"
	fi

	if use mpi; then
		local mpi_configuration="using mpi ;"
	fi

	cat > "${user_config_jam}" <<- __EOF__ || die
		using ${compiler} : ${compiler_version} : ${compiler_executable} : <cflags>"${CFLAGS}" <cxxflags>"${CXXFLAGS}" <linkflags>"${LDFLAGS}" ;
		${mpi_configuration}
	__EOF__

	if python_bindings_needed; then
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

	if python_bindings_needed && use numpy; then
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
	if python_bindings_needed; then
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
	# Workaround for too many parallel processes requested, bug #506064
	[[ "$(makeopts_jobs)" -gt 64 ]] && MAKEOPTS="${MAKEOPTS} -j64"

	OPTIONS=(
		$(usex debug gentoodebug gentoorelease)
		"-j$(makeopts_jobs)"
		-q
		-d+2
		pch=off
		$(usex icu "-sICU_PATH=${ESYSROOT}/usr" '--disable-icu boost.locale.icu=off')
		$(usex mpi '' '--without-mpi')
		$(usex nls '' '--without-locale')
		$(usex context '' '--without-context --without-coroutine --without-fiber')
		$(usex threads '' '--without-thread')
		--without-stacktrace
		--boost-build="${BROOT}"/usr/share/boost-build
		--prefix="${ED}/usr"
		--layout=system
		# CMake has issues working with multiple python impls,
		# disable cmake config generation for the time being
		# https://github.com/boostorg/python/issues/262#issuecomment-483069294
		--no-cmake-config
		# building with threading=single is currently not possible
		# https://svn.boost.org/trac/boost/ticket/7105
		threading=multi
		link=$(usex static-libs shared,static shared)
		# this seems to be the only way to disable compression algorithms
		# https://www.boost.org/doc/libs/1_70_0/libs/iostreams/doc/installation.html#boost-build
		-sNO_BZIP2=$(usex bzip2 0 1)
		-sNO_LZMA=$(usex lzma 0 1)
		-sNO_ZLIB=$(usex zlib 0 1)
		-sNO_ZSTD=$(usex zstd 0 1)
	)

	if [[ ${CHOST} == *-darwin* ]]; then
		# We need to add the prefix, and in two cases this exceeds, so prepare
		# for the largest possible space allocation.
		append-ldflags -Wl,-headerpad_max_install_names
	fi

	# Use C++14 globally as of 1.62
	append-cxxflags -std=c++14
}

multilib_src_compile() {
	ejam "${OPTIONS[@]}" || die

	if tools_needed; then
		pushd tools >/dev/null || die
		ejam \
			"${OPTIONS[@]}" \
			|| die "Building of Boost tools failed"
		popd >/dev/null || die
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
				python_domodule "${S}"/libs/mpi/build/__init__.py

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
}

multilib_src_install() {
	ejam \
		"${OPTIONS[@]}" \
		--includedir="${ED}/usr/include" \
		--libdir="${ED}/usr/$(get_libdir)" \
		install || die "Installation of Boost libraries failed"

	pushd "${ED}/usr/$(get_libdir)" >/dev/null || die

	local ext=$(get_libname)
	if use threads; then
		local f
		for f in *${ext}; do
			dosym ${f} /usr/$(get_libdir)/${f/${ext}/-mt${ext}}
		done
	fi

	popd >/dev/null || die

	if tools_needed; then
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
				refs=$(otool -XL "${d}" | \
					sed -e '1d' -e 's/^\t//' | \
					grep "^libboost_" | \
					cut -f1 -d' ')
				local r
				for r in ${refs}; do
					ebegin "    correcting reference to ${r}"
					install_name_tool -change \
						"${r}" \
						"${EPREFIX}/usr/lib/${r}" \
						"${d}"
					eend $?
				done
			fi
		done
	fi
}

pkg_preinst() {
	# Yai for having symlinks that are nigh-impossible to remove without
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
	elog "requires a complete rebuild of the boost-dependent ecosystem."
	elog
	elog "See for instance https://bugs.gentoo.org/638138"
}
