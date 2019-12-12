# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
WANT_AUTOCONF="2.1"
inherit autotools toolchain-funcs pax-utils mozcoreconf-v5

MY_PN="mozjs"
MY_P="${MY_PN}-${PV/_rc/.rc}"
MY_P="${MY_P/_pre/pre}"
DESCRIPTION="Stand-alone JavaScript C++ library"
HOMEPAGE="https://developer.mozilla.org/en-US/docs/Mozilla/Projects/SpiderMonkey"
#SRC_URI="https://people.mozilla.org/~sfink/${MY_P}.tar.bz2"
SRC_URI="http://ftp.mozilla.org/pub/spidermonkey/prereleases/52/pre1/mozjs-52.9.1pre1.tar.bz2 -> ${MY_P}.tar.bz2
	https://dev.gentoo.org/~axs/distfiles/${PN}-52.0-patches-0.tar.xz"

LICENSE="NPL-1.1"
SLOT="52"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~x86"
IUSE="debug minimal +system-icu test"

RESTRICT="!test? ( test ) ia64? ( test )"

S="${WORKDIR}/${MY_P%.rc*}"
BUILDDIR="${S}/jsobj"

RDEPEND=">=dev-libs/nspr-4.13.1
	virtual/libffi
	sys-libs/readline:0=
	>=sys-libs/zlib-1.2.3
	system-icu? ( >=dev-libs/icu-58.1:= )"
DEPEND="${RDEPEND}"

pkg_setup(){
	[[ ${MERGE_TYPE} == "binary" ]] || \
		moz_pkgsetup

	export SHELL="${EPREFIX}/bin/bash"
}

src_prepare() {
	# remove patches integrated by upstream
	rm -f	"${WORKDIR}"/${PN}/0002-build-Add-major-version-to-make-parallel-installable.patch \
		"${WORKDIR}"/${PN}/0005-headers-Fix-symbols-visibility.patch \
		"${WORKDIR}"/${PN}/0007-build-Remove-unnecessary-NSPR-dependency.patch \
		"${WORKDIR}"/${PN}/0008-tests-Skip-on-all-64-bit-archs.patch \
		|| die

	eapply "${WORKDIR}/${PN}"
	eapply "${FILESDIR}"/moz38-dont-hardcode-libc-soname.patch
	eapply "${FILESDIR}"/${PN}-52.0-fix-alpha-bitness.patch
	eapply "${FILESDIR}"/${PN}-52.0-gcc9-overflow.patch

	eapply_user

	if [[ ${CHOST} == *-freebsd* ]]; then
		# Don't try to be smart, this does not work in cross-compile anyway
		ln -sfn "${BUILDDIR}/config/Linux_All.mk" "${S}/config/$(uname -s)$(uname -r).mk" || die
	fi

	cd "${S}"/js/src || die
	eautoconf old-configure.in
	eautoconf

	# remove options that are not correct from js-config
	sed '/lib-filenames/d' -i "${S}"/js/src/js-config.in || die "failed to remove invalid option from js-config"

	# there is a default config.cache that messes everything up
	rm -f "${S}"/js/src/config.cache || die

	mkdir -p "${BUILDDIR}" || die
}

src_configure() {
	cd "${BUILDDIR}" || die

	ECONF_SOURCE="${S}/js/src" \
	econf \
		--enable-jemalloc \
		--enable-readline \
		--with-system-nspr \
		--disable-optimize \
		--with-intl-api \
		--disable-gold \
		$(use_with system-icu) \
		$(use_enable debug) \
		$(use_enable test tests) \
		XARGS="/usr/bin/xargs" \
		SHELL="${SHELL:-${EPREFIX}/bin/bash}" \
		CC="${CC}" CXX="${CXX}" LD="${LD}" AR="${AR}" RANLIB="${RANLIB}"
}

cross_make() {
	emake \
		CFLAGS="${BUILD_CFLAGS}" \
		CXXFLAGS="${BUILD_CXXFLAGS}" \
		AR="${BUILD_AR}" \
		CC="${BUILD_CC}" \
		CXX="${BUILD_CXX}" \
		RANLIB="${BUILD_RANLIB}" \
		SHELL="${SHELL:-${EPREFIX}/bin/bash}" \
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

	MOZ_MAKE_FLAGS="${MAKEOPTS}" \
	SHELL="${SHELL:-${EPREFIX}/bin/bash}" \
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
	SHELL="${SHELL:-${EPREFIX}/bin/bash}" \
	emake DESTDIR="${D}" install

	if ! use minimal; then
		pax-mark m "${ED}"usr/bin/js${SLOT}
	else
		rm -f "${ED}"usr/bin/js${SLOT}
	fi

	# We can't actually disable building of static libraries
	# They're used by the tests and in a few other places
	find "${D}" -iname '*.a' -o -iname '*.ajs' -delete || die
}
