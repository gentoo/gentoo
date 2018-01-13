# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
WANT_AUTOCONF="2.1"
inherit autotools toolchain-funcs pax-utils mozcoreconf-v4

MY_PN="mozjs"
MY_P="${MY_PN}-${PV/_/.}"
DESCRIPTION="Stand-alone JavaScript C library"
HOMEPAGE="https://developer.mozilla.org/en-US/docs/Mozilla/Projects/SpiderMonkey"
SRC_URI="https://people.mozilla.org/~sstangl/${MY_P}.tar.bz2
	https://dev.gentoo.org/~axs/distfiles/${PN}-slot38-patches-01.tar.xz"

LICENSE="NPL-1.1"
SLOT="38"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc x86 ~x86-fbsd"
IUSE="debug +jit minimal static-libs +system-icu test"

RESTRICT="ia64? ( test )"

#S="${WORKDIR}/${MY_P%.rc*}"
S="${WORKDIR}/${MY_PN}-${SLOT}.0.0"
BUILDDIR="${S}/js/src"

RDEPEND=">=dev-libs/nspr-4.10.10
	virtual/libffi
	sys-libs/readline:0=
	>=sys-libs/zlib-1.2.3
	system-icu? ( >=dev-libs/icu-51.1:= )"
DEPEND="${RDEPEND}"

pkg_setup(){
	if [[ ${MERGE_TYPE} != "binary" ]]; then
		moz_pkgsetup
	fi
}

src_prepare() {
	eapply "${WORKDIR}"/sm38/${PN}-38-jsapi-tests.patch \
		"${WORKDIR}"/sm38/mozjs38-1269317.patch \
		"${WORKDIR}"/sm38/mozjs38-fix-tracelogger.patch \
		"${WORKDIR}"/sm38/mozjs38-copy-headers.patch \
		"${WORKDIR}"/sm38/mozjs38-pkg-config-version.patch \
		"${WORKDIR}"/sm38/mozilla_configure_regexp_esr38.patch \
		"${FILESDIR}"/moz38-dont-hardcode-libc-soname.patch

	eapply_user

	if [[ ${CHOST} == *-freebsd* ]]; then
		# Don't try to be smart, this does not work in cross-compile anyway
		ln -sfn "${BUILDDIR}/config/Linux_All.mk" "${S}/config/$(uname -s)$(uname -r).mk" || die
	fi

	cd "${BUILDDIR}" || die
	eautoconf
}

src_configure() {
	export SHELL="${SHELL:-${EPREFIX%/}/bin/bash}"

	cd "${BUILDDIR}" || die

	econf \
		--enable-jemalloc \
		--enable-readline \
		--enable-threadsafe \
		--with-system-nspr \
		--enable-system-ffi \
		--disable-optimize \
		--with-intl-api \
		$(use_with system-icu) \
		$(use_enable debug) \
		$(use_enable jit yarr-jit) \
		$(use_enable jit ion) \
		$(use_enable static-libs static) \
		$(use_enable test tests)
}

cross_make() {
	emake \
		CFLAGS="${BUILD_CFLAGS}" \
		CXXFLAGS="${BUILD_CXXFLAGS}" \
		AR="${BUILD_AR}" \
		CC="${BUILD_CC}" \
		CXX="${BUILD_CXX}" \
		RANLIB="${BUILD_RANLIB}" \
		"$@"
}
src_compile() {
	cd "${BUILDDIR}" || die
	if tc-is-cross-compiler; then
		tc-export_build_env BUILD_{AR,CC,CXX,RANLIB}
		cross_make \
			MOZ_OPTIMIZE_FLAGS="" MOZ_DEBUG_FLAGS="" \
			HOST_OPTIMIZE_FLAGS="" MODULE_OPTIMIZE_FLAGS="" \
			MOZ_PGO_OPTIMIZE_FLAGS="" \
			host_jsoplengen host_jskwgen
		cross_make \
			MOZ_OPTIMIZE_FLAGS="" MOZ_DEBUG_FLAGS="" HOST_OPTIMIZE_FLAGS="" \
			-C config nsinstall
		mv {,native-}host_jskwgen || die
		mv {,native-}host_jsoplengen || die
		mv config/{,native-}nsinstall || die
		sed -i \
			-e 's@./host_jskwgen@./native-host_jskwgen@' \
			-e 's@./host_jsoplengen@./native-host_jsoplengen@' \
			Makefile || die
		sed -i -e 's@/nsinstall@/native-nsinstall@' config/config.mk || die
		rm -f config/host_nsinstall.o \
			config/host_pathsub.o \
			host_jskwgen.o \
			host_jsoplengen.o || die
	fi

	MOZ_MAKE_FLAGS="${MAKEOPTS}"
	emake \
		MOZ_OPTIMIZE_FLAGS="" MOZ_DEBUG_FLAGS="" \
		HOST_OPTIMIZE_FLAGS="" MODULE_OPTIMIZE_FLAGS="" \
		MOZ_PGO_OPTIMIZE_FLAGS=""
}

src_test() {
	cd "${BUILDDIR}/js/src/jsapi-tests" || die
	./jsapi-tests || die
}

src_install() {
	cd "${BUILDDIR}" || die
	emake DESTDIR="${D}" install

	mv "${ED}"usr/bin/js-config{,${SLOT}} || die
	mv "${ED}"usr/bin/js{,${SLOT}} || die
	if ! use minimal; then
		if use jit; then
			pax-mark m "${ED}"usr/bin/js${SLOT}
		fi
	else
		rm -f "${ED}"/usr/bin/js${SLOT}
	fi

	if ! use static-libs; then
		# We can't actually disable building of static libraries
		# They're used by the tests and in a few other places
		find "${D}" -iname '*.a' -o -iname '*.ajs' -delete || die
	fi
}
