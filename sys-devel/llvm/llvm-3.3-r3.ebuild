# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/llvm/llvm-3.3-r3.ebuild,v 1.14 2015/04/16 11:55:18 voyageur Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 pypy )

inherit cmake-utils eutils flag-o-matic multilib multilib-minimal \
	python-r1 toolchain-funcs pax-utils check-reqs

DESCRIPTION="Low Level Virtual Machine"
HOMEPAGE="http://llvm.org/"
SRC_URI="http://llvm.org/releases/${PV}/${P}.src.tar.gz
	clang? ( http://llvm.org/releases/${PV}/compiler-rt-${PV}.src.tar.gz
		http://llvm.org/releases/${PV}/cfe-${PV}.src.tar.gz )
	!doc? ( http://dev.gentoo.org/~voyageur/distfiles/${P}-manpages.tar.bz2 )"

LICENSE="UoI-NCSA"
SLOT="0/${PV}"
KEYWORDS="amd64 arm ppc ppc64 x86 ~amd64-fbsd ~x86-fbsd ~x64-freebsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="clang debug doc gold +libffi multitarget ocaml python
	+static-analyzer test udis86 xml video_cards_radeon
	kernel_Darwin kernel_FreeBSD"

COMMON_DEPEND="
	sys-libs/zlib:0=
	clang? (
		python? ( ${PYTHON_DEPS} )
		static-analyzer? (
			dev-lang/perl:*
			${PYTHON_DEPS}
		)
		xml? ( dev-libs/libxml2:2= )
	)
	gold? ( >=sys-devel/binutils-2.22:*[cxx] )
	libffi? ( >=virtual/libffi-3.0.13-r1:0=[${MULTILIB_USEDEP}] )
	ocaml? ( dev-lang/ocaml:0= )
	udis86? ( >=dev-libs/udis86-1.7-r2:0=[pic(+),${MULTILIB_USEDEP}] )"
DEPEND="${COMMON_DEPEND}
	dev-lang/perl
	>=sys-devel/make-3.81
	>=sys-devel/flex-2.5.4
	>=sys-devel/bison-1.875d
	|| ( >=sys-devel/gcc-3.0 >=sys-devel/gcc-apple-4.2.1
		( >=sys-freebsd/freebsd-lib-9.1-r10 sys-libs/libcxx )
	)
	|| ( >=sys-devel/binutils-2.18 >=sys-devel/binutils-apple-3.2.3 )
	clang? ( xml? ( virtual/pkgconfig ) )
	doc? ( dev-python/sphinx )
	libffi? ( virtual/pkgconfig )
	${PYTHON_DEPS}"
RDEPEND="${COMMON_DEPEND}
	clang? ( !<=sys-devel/clang-3.3-r99
		!>=sys-devel/clang-9999 )
	abi_x86_32? ( !<=app-emulation/emul-linux-x86-baselibs-20130224-r2
		!app-emulation/emul-linux-x86-baselibs[-abi_x86_32(-)] )"

# pypy gives me around 1700 unresolved tests due to open file limit
# being exceeded. probably GC does not close them fast enough.
REQUIRED_USE="${PYTHON_REQUIRED_USE}
	test? ( || ( $(python_gen_useflags 'python*') ) )"

S=${WORKDIR}/${P}.src

# Some people actually override that in make.conf. That sucks since
# we need to run install per-directory, and ninja can't do that...
# so why did it call itself ninja in the first place?
CMAKE_MAKEFILE_GENERATOR=emake

pkg_pretend() {
	# in megs
	# !clang !debug !multitarget -O2       400
	# !clang !debug  multitarget -O2       550
	#  clang !debug !multitarget -O2       950
	#  clang !debug  multitarget -O2      1200
	# !clang  debug  multitarget -O2      5G
	#  clang !debug  multitarget -O0 -g  12G
	#  clang  debug  multitarget -O2     16G
	#  clang  debug  multitarget -O0 -g  14G

	local build_size=550
	use clang && build_size=1200

	if use debug; then
		ewarn "USE=debug is known to increase the size of package considerably"
		ewarn "and cause the tests to fail."
		ewarn

		(( build_size *= 14 ))
	elif is-flagq '-g?(gdb)?([1-9])'; then
		ewarn "The C++ compiler -g option is known to increase the size of the package"
		ewarn "considerably. If you run out of space, please consider removing it."
		ewarn

		(( build_size *= 10 ))
	fi

	# Multiply by number of ABIs :).
	local abis=( $(multilib_get_enabled_abis) )
	(( build_size *= ${#abis[@]} ))

	local CHECKREQS_DISK_BUILD=${build_size}M
	check-reqs_pkg_pretend
}

pkg_setup() {
	pkg_pretend

	# need to check if the active compiler is ok

	broken_gcc=( 3.2.2 3.2.3 3.3.2 4.1.1 )
	broken_gcc_x86=( 3.4.0 3.4.2 )
	broken_gcc_amd64=( 3.4.6 )

	gcc_vers=$(gcc-fullversion)

	if has "${gcc_vers}" "${broken_gcc[@]}"; then
		elog "Your version of gcc is known to miscompile llvm."
		elog "Check http://www.llvm.org/docs/GettingStarted.html for"
		elog "possible solutions."
		die "Your currently active version of gcc is known to miscompile llvm"
	fi

	if use abi_x86_32 && has "${gcc_vers}" "${broken_gcc_x86[@]}"; then
		elog "Your version of gcc is known to miscompile llvm on x86"
		elog "architectures.  Check"
		elog "http://www.llvm.org/docs/GettingStarted.html for possible"
		elog "solutions."
		die "Your currently active version of gcc is known to miscompile llvm"
	fi

	if use abi_x86_64 && has "${gcc_vers}" "${broken_gcc_amd64[@]}"; then
		elog "Your version of gcc is known to miscompile llvm in amd64"
		elog "architectures.  Check"
		elog "http://www.llvm.org/docs/GettingStarted.html for possible"
		elog "solutions."
		die "Your currently active version of gcc is known to miscompile llvm"
	fi
}

src_unpack() {
	default

	rm -f "${S}"/tools/clang "${S}"/projects/compiler-rt \
		|| die "symlinks removal failed"

	if use clang; then
		mv "${WORKDIR}"/cfe-${PV}.src "${S}"/tools/clang \
			|| die "clang source directory move failed"
		mv "${WORKDIR}"/compiler-rt-${PV}.src "${S}"/projects/compiler-rt \
			|| die "compiler-rt source directory move failed"
	fi
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-3.2-nodoctargz.patch
	epatch "${FILESDIR}"/${P}-R600_debug.patch
	epatch "${FILESDIR}"/${PN}-3.3-r2-gentoo-install.patch

	# Hack cmake search path for Gentoo, bug #496480
	epatch "${FILESDIR}"/${PN}-3.3-cmake-modulepath.patch

	if use clang; then
		# Automatically select active system GCC's libraries, bugs #406163 and #417913
		epatch "${FILESDIR}"/clang-3.1-gentoo-runtime-gcc-detection-v3.patch

		epatch "${FILESDIR}"/clang-3.3-gentoo-install.patch

		# backport support for g++-X.Y header location
		epatch "${FILESDIR}"/clang-3.3-gcc-header-path.patch
	fi

	local sub_files=(
		Makefile.config.in
		Makefile.rules
		tools/llvm-config/llvm-config.cpp
	)
	use clang && sub_files+=(
		tools/clang/lib/Driver/Tools.cpp
		tools/clang/tools/scan-build/scan-build
	)

	# unfortunately ./configure won't listen to --mandir and the-like, so take
	# care of this.
	# note: we're setting the main libdir intentionally.
	# where per-ABI is appropriate, we use $(GENTOO_LIBDIR) make.
	einfo "Fixing install dirs"
	sed -e "s,@libdir@,$(get_libdir),g" \
		-e "s,@PF@,${PF},g" \
		-e "s,@EPREFIX@,${EPREFIX},g" \
		-i "${sub_files[@]}" \
		|| die "install paths sed failed"

	# User patches
	epatch_user

	python_setup
}

multilib_src_configure() {
	# disable timestamps since they confuse ccache
	local conf_flags=(
		--disable-timestamps
		--enable-keep-symbols
		--enable-shared
		--with-optimize-option=
		$(use_enable !debug optimized)
		$(use_enable debug assertions)
		$(use_enable debug expensive-checks)
		$(use_enable libffi)
	)

	if use clang; then
		conf_flags+=( --with-clang-resource-dir=../lib/clang/${PV} )
	fi
	# well, it's used only by clang executable c-index-test
	if multilib_is_native_abi && use clang && use xml; then
		conf_flags+=( XML2CONFIG="$(tc-getPKG_CONFIG) libxml-2.0" )
	else
		conf_flags+=( ac_cv_prog_XML2CONFIG="" )
	fi

	local targets bindings
	if use multitarget; then
		targets='all'
	else
		targets='host,cpp'
	fi
	conf_flags+=( --enable-targets=${targets} )

	if use video_cards_radeon; then
		conf_flags+=( --enable-experimental-targets=R600 )
	fi

	if multilib_is_native_abi; then
		use gold && conf_flags+=( --with-binutils-include="${EPREFIX}"/usr/include/ )
		# extra commas don't hurt
		use ocaml && bindings+=',ocaml'
	fi

	[[ ${bindings} ]] || bindings='none'
	conf_flags+=( --enable-bindings=${bindings} )

	if use udis86; then
		conf_flags+=( --with-udis86 )
	fi

	if use libffi; then
		local CPPFLAGS=${CPPFLAGS}
		append-cppflags "$(pkg-config --cflags libffi)"
	fi

	# llvm prefers clang over gcc, so we may need to force that
	tc-export CC CXX

	ECONF_SOURCE=${S} \
	econf "${conf_flags[@]}"

	multilib_is_native_abi && cmake_configure
}

cmake_configure() {
	# sadly, cmake doesn't seem to have host autodetection
	# but it's fairly easy to steal this from configured autotools
	local targets=$(sed -n -e 's/^TARGETS_TO_BUILD=//p' Makefile.config || die)
	local libdir=$(get_libdir)

	# cmake doesn't have R600 in 3.3
	targets=${targets/R600 /}

	local mycmakeargs=(
		-DLLVM_TARGETS_TO_BUILD="${targets// /;}"
		-DLLVM_LIBDIR_SUFFIX=${libdir#lib}
	)

	BUILD_DIR=${S%/}_cmake \
	cmake-utils_src_configure
}

set_makeargs() {
	MAKEARGS=(
		VERBOSE=1
		REQUIRES_RTTI=1
		GENTOO_LIBDIR=$(get_libdir)
	)

	# for tests, we want it all! otherwise, we may use a little filtering...
	# adding ONLY_TOOLS also disables unittest building...
	if [[ ${EBUILD_PHASE_FUNC} != src_test ]]; then
		local tools=( llvm-config )
		use clang && tools+=( clang )

		if multilib_is_native_abi; then
			tools+=(
				opt llvm-as llvm-dis llc llvm-ar llvm-nm llvm-link lli
				llvm-extract llvm-mc llvm-bcanalyzer llvm-diff macho-dump
				llvm-objdump llvm-readobj llvm-rtdyld llvm-dwarfdump llvm-cov
				llvm-size llvm-stress llvm-mcmarkup llvm-symbolizer obj2yaml
				yaml2obj lto llvm-prof llvm-ranlib bugpoint
			)

			# those tools require 'lto' built first, so we need to delay
			# building them to a second run
			if [[ ${1} != -1 ]]; then
				use gold && tools+=( gold )
			fi
		fi

		MAKEARGS+=(
			# filter tools + disable unittests implicitly
			ONLY_TOOLS="${tools[*]}"

			# this disables unittests & docs from clang
			BUILD_CLANG_ONLY=YES
		)
	fi
}

multilib_src_compile() {
	local MAKEARGS
	set_makeargs -1
	emake "${MAKEARGS[@]}"

	if multilib_is_native_abi; then
		set_makeargs
		emake -C tools "${MAKEARGS[@]}"

		if use doc; then
			emake -C "${S}"/docs -f Makefile.sphinx man
			use clang && emake -C "${S}"/tools/clang/docs/tools \
				BUILD_FOR_WEBSITE=1 DST_MAN_DIR="${T}"/ man
			emake -C "${S}"/docs -f Makefile.sphinx html
		fi
	fi

	if use debug; then
		pax-mark m Debug+Asserts+Checks/bin/llvm-rtdyld
		pax-mark m Debug+Asserts+Checks/bin/lli
	else
		pax-mark m Release/bin/llvm-rtdyld
		pax-mark m Release/bin/lli
	fi
}

multilib_src_test() {
	local MAKEARGS
	set_makeargs

	# build the remaining tools & unittests
	emake "${MAKEARGS[@]}"

	pax-mark m unittests/ExecutionEngine/JIT/Release/JITTests
	pax-mark m unittests/ExecutionEngine/MCJIT/Release/MCJITTests
	pax-mark m unittests/Support/Release/SupportTests

	emake "${MAKEARGS[@]}" check
	use clang && emake "${MAKEARGS[@]}" -C tools/clang test
}

src_install() {
	local MULTILIB_WRAPPED_HEADERS=(
		/usr/include/llvm/Config/config.h
		/usr/include/llvm/Config/llvm-config.h
	)

	use clang && MULTILIB_WRAPPED_HEADERS+=(
		/usr/include/clang/Config/config.h
	)

	multilib-minimal_src_install

	# Remove unnecessary headers on FreeBSD, bug #417171
	use kernel_FreeBSD && use clang && rm "${ED}"usr/lib/clang/${PV}/include/{std,float,iso,limits,tgmath,varargs}*.h
}

multilib_src_install() {
	local MAKEARGS
	set_makeargs

	emake "${MAKEARGS[@]}" DESTDIR="${D}" install

	# Preserve ABI-variant of llvm-config.
	dodir /tmp
	mv "${ED}"/usr/bin/llvm-config "${ED}"/tmp/"${CHOST}"-llvm-config || die

	if ! multilib_is_native_abi; then
		# Drop all the executables since LLVM doesn't like to
		# clobber when installing.
		rm -r "${ED}"/usr/bin || die

		# Backwards compat, will be happily removed someday.
		dosym "${CHOST}"-llvm-config /tmp/llvm-config.${ABI}
	else
		# Move files back.
		mv "${ED}"/tmp/*llvm-config* "${ED}"/usr/bin || die
		# Create a symlink for host's llvm-config.
		dosym "${CHOST}"-llvm-config /usr/bin/llvm-config

		# Install docs.
		if use doc; then
			doman "${S}"/docs/_build/man/*.1
			use clang && doman "${T}"/clang.1
			dohtml -r "${S}"/docs/_build/html/
		else
			doman "${WORKDIR}"/${P}-manpages/*.1
		fi

		# Symlink the gold plugin.
		if use gold; then
			dodir /usr/${CHOST}/binutils-bin/lib/bfd-plugins
			dosym ../../../../$(get_libdir)/LLVMgold.so \
				/usr/${CHOST}/binutils-bin/lib/bfd-plugins/LLVMgold.so
		fi

		# install cmake modules
		emake -C "${S%/}"_cmake/cmake/modules DESTDIR="${D}" install
	fi

	# Fix install_names on Darwin.  The build system is too complicated
	# to just fix this, so we correct it post-install
	local lib= f= odylib= libpv=${PV}
	if [[ ${CHOST} == *-darwin* ]] ; then
		eval $(grep PACKAGE_VERSION= configure)
		[[ -n ${PACKAGE_VERSION} ]] && libpv=${PACKAGE_VERSION}
		for lib in lib{EnhancedDisassembly,LLVM-${libpv},LTO,profile_rt,clang}.dylib LLVMHello.dylib ; do
			# libEnhancedDisassembly is Darwin10 only, so non-fatal
			# + omit clang libs if not enabled
			[[ -f ${ED}/usr/lib/${lib} ]] || continue

			ebegin "fixing install_name of $lib"
			install_name_tool \
				-id "${EPREFIX}"/usr/lib/${lib} \
				"${ED}"/usr/lib/${lib}
			eend $?
		done
		for f in "${ED}"/usr/bin/* "${ED}"/usr/lib/lib{LTO,clang}.dylib ; do
			# omit clang libs if not enabled
			[[ -f ${ED}/usr/lib/${lib} ]] || continue

			odylib=$(scanmacho -BF'%n#f' "${f}" | tr ',' '\n' | grep libLLVM-${libpv}.dylib)
			ebegin "fixing install_name reference to ${odylib} of ${f##*/}"
			install_name_tool \
				-change "${odylib}" \
					"${EPREFIX}"/usr/lib/libLLVM-${libpv}.dylib \
				-change "@rpath/libclang.dylib" \
					"${EPREFIX}"/usr/lib/libclang.dylib \
				-change "${S}"/Release/lib/libclang.dylib \
					"${EPREFIX}"/usr/lib/libclang.dylib \
				"${f}"
			eend $?
		done
	fi
}

multilib_src_install_all() {
	insinto /usr/share/vim/vimfiles/syntax
	doins utils/vim/*.vim

	if use clang; then
		cd tools/clang || die

		if use static-analyzer ; then
			dobin tools/scan-build/ccc-analyzer
			dosym ccc-analyzer /usr/bin/c++-analyzer
			dobin tools/scan-build/scan-build

			insinto /usr/share/${PN}
			doins tools/scan-build/scanview.css
			doins tools/scan-build/sorttable.js
		fi

		python_inst() {
			if use static-analyzer ; then
				pushd tools/scan-view >/dev/null || die

				python_doscript scan-view

				touch __init__.py || die
				python_moduleinto clang
				python_domodule __init__.py Reporter.py Resources ScanView.py startfile.py

				popd >/dev/null || die
			fi

			if use python ; then
				pushd bindings/python/clang >/dev/null || die

				python_moduleinto clang
				python_domodule __init__.py cindex.py enumerations.py

				popd >/dev/null || die
			fi

			# AddressSanitizer symbolizer (currently separate)
			python_doscript "${S}"/projects/compiler-rt/lib/asan/scripts/asan_symbolize.py
		}
		python_foreach_impl python_inst
	fi
}
