# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/llvm/llvm-3.0-r2.ebuild,v 1.9 2013/01/03 23:29:51 voyageur Exp $

EAPI="4"
PYTHON_DEPEND="2"
inherit eutils flag-o-matic multilib toolchain-funcs python pax-utils

DESCRIPTION="Low Level Virtual Machine"
HOMEPAGE="http://llvm.org/"
SRC_URI="http://llvm.org/releases/${PV}/${P}.tar.gz"

LICENSE="UoI-NCSA"
SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="debug gold +libffi multitarget ocaml test udis86 vim-syntax"

DEPEND="dev-lang/perl
	>=sys-devel/make-3.79
	>=sys-devel/flex-2.5.4
	>=sys-devel/bison-1.875d
	|| ( >=sys-devel/gcc-3.0 >=sys-devel/gcc-apple-4.2.1 )
	|| ( >=sys-devel/binutils-2.18 >=sys-devel/binutils-apple-3.2.3 )
	gold? ( >=sys-devel/binutils-2.22[cxx] )
	libffi? ( virtual/pkgconfig
		virtual/libffi )
	ocaml? ( dev-lang/ocaml )
	udis86? ( dev-libs/udis86[pic(+)] )"
RDEPEND="dev-lang/perl
	libffi? ( virtual/libffi )
	vim-syntax? ( || ( app-editors/vim app-editors/gvim ) )"

S=${WORKDIR}/${P}.src

pkg_setup() {
	# Required for test and build
	python_set_active_version 2
	python_pkg_setup

	# need to check if the active compiler is ok

	broken_gcc=" 3.2.2 3.2.3 3.3.2 4.1.1 "
	broken_gcc_x86=" 3.4.0 3.4.2 "
	broken_gcc_amd64=" 3.4.6 "

	gcc_vers=$(gcc-fullversion)

	if [[ ${broken_gcc} == *" ${version} "* ]] ; then
		elog "Your version of gcc is known to miscompile llvm."
		elog "Check http://www.llvm.org/docs/GettingStarted.html for"
		elog "possible solutions."
		die "Your currently active version of gcc is known to miscompile llvm"
	fi

	if [[ ${CHOST} == i*86-* && ${broken_gcc_x86} == *" ${version} "* ]] ; then
		elog "Your version of gcc is known to miscompile llvm on x86"
		elog "architectures.  Check"
		elog "http://www.llvm.org/docs/GettingStarted.html for possible"
		elog "solutions."
		die "Your currently active version of gcc is known to miscompile llvm"
	fi

	if [[ ${CHOST} == x86_64-* && ${broken_gcc_amd64} == *" ${version} "* ]];
	then
		 elog "Your version of gcc is known to miscompile llvm in amd64"
		 elog "architectures.  Check"
		 elog "http://www.llvm.org/docs/GettingStarted.html for possible"
		 elog "solutions."
		die "Your currently active version of gcc is known to miscompile llvm"
	 fi
}

src_prepare() {
	# unfortunately ./configure won't listen to --mandir and the-like, so take
	# care of this.
	einfo "Fixing install dirs"
	sed -e 's,^PROJ_docsdir.*,PROJ_docsdir := $(PROJ_prefix)/share/doc/'${PF}, \
		-e 's,^PROJ_etcdir.*,PROJ_etcdir := '"${EPREFIX}"'/etc/llvm,' \
		-e 's,^PROJ_libdir.*,PROJ_libdir := $(PROJ_prefix)/'$(get_libdir)/${PN}, \
		-i Makefile.config.in || die "Makefile.config sed failed"
	sed -e 's,$ABS_RUN_DIR/lib,'"${EPREFIX}"/usr/$(get_libdir)/${PN}, \
		-i tools/llvm-config/llvm-config.in.in || die "llvm-config sed failed"

	einfo "Fixing rpath and CFLAGS"
	sed -e 's,\$(RPATH) -Wl\,\$(\(ToolDir\|LibDir\)),$(RPATH) -Wl\,'"${EPREFIX}"/usr/$(get_libdir)/${PN}, \
		-e '/OmitFramePointer/s/-fomit-frame-pointer//' \
		-i Makefile.rules || die "rpath sed failed"

	# Specify python version
	python_convert_shebangs -r 2 test/Scripts

	epatch "${FILESDIR}"/${PN}-2.6-commandguide-nops.patch
	epatch "${FILESDIR}"/${PN}-2.9-nodoctargz.patch
	epatch "${FILESDIR}"/${P}-ocaml_install.patch
	epatch "${FILESDIR}"/${P}-PPC_macro.patch
	epatch "${FILESDIR}"/${P}-PPCCompilationCallbackC_static.patch
	epatch "${FILESDIR}"/${P}-gold_LTO_link.patch
	epatch "${FILESDIR}"/${P}-set_soname.patch

	# User patches
	epatch_user
}

src_configure() {
	local CONF_FLAGS="--enable-shared
		--with-optimize-option=
		$(use_enable !debug optimized)
		$(use_enable debug assertions)
		$(use_enable debug expensive-checks)"

	if use multitarget; then
		CONF_FLAGS="${CONF_FLAGS} --enable-targets=all"
	else
		CONF_FLAGS="${CONF_FLAGS} --enable-targets=host-only"
	fi

	if use amd64; then
		CONF_FLAGS="${CONF_FLAGS} --enable-pic"
	fi

	if use gold; then
		CONF_FLAGS="${CONF_FLAGS} --with-binutils-include=${EPREFIX}/usr/include/"
	fi
	if use ocaml; then
		CONF_FLAGS="${CONF_FLAGS} --enable-bindings=ocaml"
	else
		CONF_FLAGS="${CONF_FLAGS} --enable-bindings=none"
	fi

	if use udis86; then
		CONF_FLAGS="${CONF_FLAGS} --with-udis86"
	fi

	if use libffi; then
		append-cppflags "$(pkg-config --cflags libffi)"
	fi
	CONF_FLAGS="${CONF_FLAGS} $(use_enable libffi)"
	econf ${CONF_FLAGS} || die "econf failed"
}

src_compile() {
	emake VERBOSE=1 KEEP_SYMBOLS=1 REQUIRES_RTTI=1 || die "emake failed"

	pax-mark m Release/bin/lli
	if use test; then
		pax-mark m unittests/ExecutionEngine/JIT/Release/JITTests
	fi
}

src_install() {
	emake KEEP_SYMBOLS=1 DESTDIR="${D}" install || die "install failed"

	if use vim-syntax; then
		insinto /usr/share/vim/vimfiles/syntax
		doins utils/vim/*.vim
	fi

	# Fix install_names on Darwin.  The build system is too complicated
	# to just fix this, so we correct it post-install
	local lib= f= odylib=
	if [[ ${CHOST} == *-darwin* ]] ; then
		for lib in lib{EnhancedDisassembly,LLVM-${PV},LTO,profile_rt}.dylib {BugpointPasses,LLVMHello}.dylib ; do
			# libEnhancedDisassembly is Darwin10 only, so non-fatal
			[[ -f ${ED}/usr/lib/${PN}/${lib} ]] || continue
			ebegin "fixing install_name of $lib"
			install_name_tool \
				-id "${EPREFIX}"/usr/lib/${PN}/${lib} \
				"${ED}"/usr/lib/${PN}/${lib}
			eend $?
		done
		for f in "${ED}"/usr/bin/* "${ED}"/usr/lib/${PN}/libLTO.dylib ; do
			odylib=$(scanmacho -BF'%n#f' "${f}" | tr ',' '\n' | grep libLLVM-${PV}.dylib)
			ebegin "fixing install_name reference to ${odylib} of ${f##*/}"
			install_name_tool \
				-change "${odylib}" \
					"${EPREFIX}"/usr/lib/${PN}/libLLVM-${PV}.dylib \
				"${f}"
			eend $?
		done
	fi
}
