# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

RESTRICT_PYTHON_ABIS="3.*"
SUPPORT_PYTHON_ABIS="1"

inherit eutils multilib python

DESCRIPTION="C language family frontend for LLVM"
HOMEPAGE="http://clang.llvm.org/"
# Fetching LLVM as well: see http://llvm.org/bugs/show_bug.cgi?id=4840
SRC_URI="http://llvm.org/releases/${PV}/llvm-${PV}.src.tar.gz
	http://llvm.org/releases/${PV}/compiler-rt-${PV}.src.tar.gz
	http://llvm.org/releases/${PV}/${P}.src.tar.gz"

LICENSE="UoI-NCSA"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86 ~amd64-fbsd ~x64-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="debug kernel_FreeBSD multitarget +static-analyzer test"

DEPEND="static-analyzer? ( dev-lang/perl )"
RDEPEND="~sys-devel/llvm-${PV}[debug=,multitarget=]"

S=${WORKDIR}/llvm-${PV}.src

src_prepare() {
	mv "${WORKDIR}"/clang-${PV}.src "${S}"/tools/clang \
		|| die "clang source directory move failed"
	mv "${WORKDIR}"/compiler-rt-${PV}.src "${S}"/projects/compiler-rt \
		|| die "compiler-rt source directory move failed"

	# Same as llvm doc patches
	epatch "${FILESDIR}"/${PN}-2.7-fixdoc.patch

	# multilib-strict
	sed -e "/PROJ_headers/s#lib/clang#$(get_libdir)/clang#" \
		-i tools/clang/lib/Headers/Makefile \
		|| die "clang Makefile failed"
	sed -e "/PROJ_resources/s#lib/clang#$(get_libdir)/clang#" \
		-i tools/clang/runtime/compiler-rt/Makefile \
		|| die "compiler-rt Makefile failed"
	# fix the static analyzer for in-tree install
	sed -e 's/import ScanView/from clang \0/'  \
		-i tools/clang/tools/scan-view/scan-view \
		|| die "scan-view sed failed"
	sed -e "/scanview.css\|sorttable.js/s#\$RealBin#${EPREFIX}/usr/share/${PN}#" \
		-i tools/clang/tools/scan-build/scan-build \
		|| die "scan-build sed failed"
	# Set correct path for gold plugin
	sed -e "/LLVMgold.so/s#lib/#$(get_libdir)/llvm/#" \
		-i  tools/clang/lib/Driver/Tools.cpp \
		|| die "gold plugin path sed failed"
	# Specify python version
	python_convert_shebangs 2 tools/clang/tools/scan-view/scan-view
	python_convert_shebangs -r 2 test/Scripts
	python_convert_shebangs 2 projects/compiler-rt/lib/asan/scripts/asan_symbolize.py

	# From llvm src_prepare
	einfo "Fixing install dirs"
	sed -e 's,^PROJ_docsdir.*,PROJ_docsdir := $(PROJ_prefix)/share/doc/'${PF}, \
		-e 's,^PROJ_etcdir.*,PROJ_etcdir := '"${EPREFIX}"'/etc/llvm,' \
		-e 's,^PROJ_libdir.*,PROJ_libdir := $(PROJ_prefix)/'$(get_libdir)/llvm, \
		-i Makefile.config.in || die "Makefile.config sed failed"

	einfo "Fixing rpath and CFLAGS"
	sed -e 's,\$(RPATH) -Wl\,\$(\(ToolDir\|LibDir\)),$(RPATH) -Wl\,'"${EPREFIX}"/usr/$(get_libdir)/llvm, \
		-e '/OmitFramePointer/s/-fomit-frame-pointer//' \
		-i Makefile.rules || die "rpath sed failed"

	# Use system llc (from llvm ebuild) for tests
	sed -e "/^llc_props =/s/os.path.join(llvm_tools_dir, 'llc')/'llc'/" \
		-i tools/clang/test/lit.cfg  || die "test path sed failed"

	# Automatically select active system GCC's libraries, bugs #406163 and #417913
	epatch "${FILESDIR}"/${P}-gentoo-runtime-gcc-detection-v3.patch

	# Fix search paths on FreeBSD, bug #409269
	epatch "${FILESDIR}"/${P}-gentoo-freebsd-fix-lib-path.patch

	# Fix regression caused by removal of USE=system-cxx-headers, bug #417541
	epatch "${FILESDIR}"/${P}-gentoo-freebsd-fix-cxx-paths-v2.patch

	# Increase recursion limit, bug #417545, upstream r155737
	epatch "${FILESDIR}"/${P}-increase-parser-recursion-limit.patch

	# Apply r600 OpenCL-related patches, bug #425688
	epatch "${FILESDIR}"/cl-patches/llvm-*.patch
	pushd tools/clang &>/dev/null || die
	epatch "${FILESDIR}"/cl-patches/clang-*.patch
	popd &>/dev/null || die

	# User patches
	epatch_user
}

src_configure() {
	local CONF_FLAGS="--enable-shared
		--with-optimize-option=
		$(use_enable !debug optimized)
		$(use_enable debug assertions)
		$(use_enable debug expensive-checks)"

	# Setup the search path to include the Prefix includes
	if use prefix ; then
		CONF_FLAGS="${CONF_FLAGS} \
			--with-c-include-dirs=${EPREFIX}/usr/include:/usr/include"
	fi

	if use multitarget; then
		CONF_FLAGS="${CONF_FLAGS} --enable-targets=all"
	else
		CONF_FLAGS="${CONF_FLAGS} --enable-targets=host,cpp"
	fi

	if use amd64; then
		CONF_FLAGS="${CONF_FLAGS} --enable-pic"
	fi

	# clang prefers clang over gcc, so we may need to force that
	tc-export CC CXX
	econf ${CONF_FLAGS}
}

src_compile() {
	emake VERBOSE=1 KEEP_SYMBOLS=1 REQUIRES_RTTI=1 clang-only
}

src_test() {
	cd "${S}"/test || die "cd failed"
	emake site.exp

	cd "${S}"/tools/clang || die "cd clang failed"

	echo ">>> Test phase [test]: ${CATEGORY}/${PF}"

	testing() {
		if ! emake -j1 VERBOSE=1 test; then
			has test $FEATURES && die "Make test failed. See above for details."
			has test $FEATURES || eerror "Make test failed. See above for details."
		fi
	}
	python_execute_function testing
}

src_install() {
	cd "${S}"/tools/clang || die "cd clang failed"
	emake KEEP_SYMBOLS=1 DESTDIR="${D}" install

	if use static-analyzer ; then
		dobin tools/scan-build/ccc-analyzer
		dosym ccc-analyzer /usr/bin/c++-analyzer
		dobin tools/scan-build/scan-build

		insinto /usr/share/${PN}
		doins tools/scan-build/scanview.css
		doins tools/scan-build/sorttable.js

		cd tools/scan-view || die "cd scan-view failed"
		dobin scan-view
		install-scan-view() {
			insinto "$(python_get_sitedir)"/clang
			doins Reporter.py Resources ScanView.py startfile.py
			touch "${ED}"/"$(python_get_sitedir)"/clang/__init__.py
		}
		python_execute_function install-scan-view
	fi

	# Fix install_names on Darwin.  The build system is too complicated
	# to just fix this, so we correct it post-install
	if [[ ${CHOST} == *-darwin* ]] ; then
		for lib in libclang.dylib ; do
			ebegin "fixing install_name of $lib"
			install_name_tool -id "${EPREFIX}"/usr/lib/llvm/${lib} \
				"${ED}"/usr/lib/llvm/${lib}
			eend $?
		done
		for f in usr/bin/{c-index-test,clang} usr/lib/llvm/libclang.dylib ; do
			ebegin "fixing references in ${f##*/}"
			install_name_tool \
				-change "@rpath/libclang.dylib" \
					"${EPREFIX}"/usr/lib/llvm/libclang.dylib \
				-change "@executable_path/../lib/libLLVM-${PV}.dylib" \
					"${EPREFIX}"/usr/lib/llvm/libLLVM-${PV}.dylib \
				-change "${S}"/Release/lib/libclang.dylib \
					"${EPREFIX}"/usr/lib/llvm/libclang.dylib \
				"${ED}"/$f
			eend $?
		done
	fi

	# Remove unnecessary headers on FreeBSD, bug #417171
	use kernel_FreeBSD && rm "${ED}"usr/$(get_libdir)/clang/${PV}/include/{arm_neon,std,float,iso,limits,tgmath,varargs}*.h
}

pkg_postinst() {
	python_mod_optimize clang
}

pkg_postrm() {
	python_mod_cleanup clang
}
