# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/spidermonkey/spidermonkey-1.8.7-r3.ebuild,v 1.9 2015/07/16 14:57:19 axs Exp $

EAPI="5"
WANT_AUTOCONF="2.1"
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="threads"
inherit autotools eutils toolchain-funcs multilib python-any-r1 versionator pax-utils

MY_PN="js"
TARBALL_PV="$(replace_all_version_separators '' $(get_version_component_range 1-3))"
MY_P="${MY_PN}-${PV}"
TARBALL_P="${MY_PN}${TARBALL_PV}-1.0.0"
SPIDERPV="${PV}-patches-0.1"
DESCRIPTION="Stand-alone JavaScript C library"
HOMEPAGE="http://www.mozilla.org/js/spidermonkey/"
SRC_URI="http://people.mozilla.com/~dmandelin/${TARBALL_P}.tar.gz
	http://dev.gentoo.org/~anarchy/mozilla/patchsets/spidermonkey-${SPIDERPV}.tar.xz"

LICENSE="NPL-1.1"
SLOT="0/mozjs187"
KEYWORDS="~alpha ~amd64 ~arm ~hppa -ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd"
IUSE="debug jit minimal static-libs test"

S="${WORKDIR}/${MY_P}"
BUILDDIR="${S}/js/src"

RDEPEND=">=dev-libs/nspr-4.7.0
	virtual/libffi"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	app-arch/zip
	virtual/pkgconfig"

pkg_setup(){
	if [[ ${MERGE_TYPE} != "binary" ]]; then
		export LC_ALL="C"
	fi
}

src_prepare() {
	# Apply patches that are required for misc archs
	EPATCH_SUFFIX="patch" \
	EPATCH_FORCE="yes" \
	epatch "${WORKDIR}/spidermonkey"

	epatch "${FILESDIR}"/${PN}-1.8.5-fix-install-symlinks.patch
	epatch "${FILESDIR}"/${PN}-1.8.7-filter_desc.patch
	epatch "${FILESDIR}"/${PN}-1.8.7-freebsd-pthreads.patch
	epatch "${FILESDIR}"/${PN}-1.8.7-x32.patch
	# https://bugs.gentoo.org/show_bug.cgi?id=439260
	epatch "${FILESDIR}"/${P}-symbol-versions.patch
	# https://bugs.gentoo.org/show_bug.cgi?id=552786
	epatch "${FILESDIR}"/${PN}-perl-defined-array-check.patch
	epatch_user

	cd "${BUILDDIR}" || die
	eautoconf
}

src_configure() {
	cd "${BUILDDIR}" || die

	CC="$(tc-getCC)" CXX="$(tc-getCXX)" \
	AR="$(tc-getAR)" RANLIB="$(tc-getRANLIB)" \
	LD="$(tc-getLD)" \
	econf \
		${myopts} \
		--enable-jemalloc \
		--enable-readline \
		--enable-threadsafe \
		--with-system-nspr \
		--enable-system-ffi \
		--enable-jemalloc \
		$(use_enable debug) \
		$(use_enable jit tracejit) \
		$(use_enable jit methodjit) \
		$(use_enable static-libs static) \
		$(use_enable test tests)
}

src_compile() {
	cd "${BUILDDIR}" || die
	if tc-is-cross-compiler; then
		make CFLAGS="" CXXFLAGS="" \
			CC=$(tc-getBUILD_CC) CXX=$(tc-getBUILD_CXX) \
			AR=$(tc-getBUILD_AR) RANLIB=$(tc-getBUILD_RANLIB) \
			jscpucfg host_jsoplengen host_jskwgen || die
		make CFLAGS="" CXXFLAGS="" \
			CC=$(tc-getBUILD_CC) CXX=$(tc-getBUILD_CXX) \
			AR=$(tc-getBUILD_AR) RANLIB=$(tc-getBUILD_RANLIB) \
			-C config nsinstall || die
		mv {,native-}jscpucfg || die
		mv {,native-}host_jskwgen || die
		mv {,native-}host_jsoplengen || die
		mv config/{,native-}nsinstall || die
		sed -e 's@./jscpucfg@./native-jscpucfg@' \
			-e 's@./host_jskwgen@./native-host_jskwgen@' \
			-e 's@./host_jsoplengen@./native-host_jsoplengen@' \
			-i Makefile || die
		sed -e 's@/nsinstall@/native-nsinstall@' -i config/config.mk || die
		rm -f config/host_nsinstall.o \
			config/host_pathsub.o \
			host_jskwgen.o \
			host_jsoplengen.o || die
	fi
	emake
}

src_test() {
	cd "${BUILDDIR}/jsapi-tests" || die
	emake check
}

src_install() {
	cd "${BUILDDIR}" || die
	emake DESTDIR="${D}" install
	if ! use minimal; then
		dobin shell/js
		if use jit; then
			pax-mark m "${ED}/usr/bin/js"
		fi
	fi
	dodoc ../../README
	dohtml README.html
	# install header files needed but not part of build system
	insinto /usr/include/js
	doins ../public/*.h
	insinto /usr/include/js/mozilla
	doins "${S}"/mfbt/*.h

	if ! use static-libs; then
		# We can't actually disable building of static libraries
		# They're used by the tests and in a few other places
		find "${D}" -iname '*.a' -delete || die
	fi
}
