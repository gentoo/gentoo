# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
WANT_AUTOCONF="2.1"
inherit autotools toolchain-funcs pax-utils mozcoreconf-v5

MY_PN="mozjs"
MY_P="${MY_PN}-${PV/_rc/.rc}"
DESCRIPTION="Stand-alone JavaScript C++ library"
HOMEPAGE="https://developer.mozilla.org/en-US/docs/Mozilla/Projects/SpiderMonkey"
#SRC_URI="https://people.mozilla.org/~sfink/${MY_P}.tar.bz2"
SRC_URI="https://dev.gentoo.org/~axs/distfiles/${MY_P}.tar.bz2
	https://dev.gentoo.org/~axs/distfiles/${PN}-52.0-patches-0.tar.xz"

LICENSE="NPL-1.1"
SLOT="52"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="debug +jit minimal +system-icu test"

RESTRICT="ia64? ( test )"

S="${WORKDIR}/${MY_P%.rc*}"
S="${S%_pre*}"
BUILDDIR="${S}/js/src"

RDEPEND=">=dev-libs/nspr-4.13.1
	virtual/libffi
	sys-libs/readline:0=
	>=sys-libs/zlib-1.2.3
	system-icu? ( >=dev-libs/icu-58.1:= )"
DEPEND="${RDEPEND}"

pkg_setup(){
	[[ ${MERGE_TYPE} == "binary" ]] || \
		moz_pkgsetup
}

src_prepare() {
	# remove patches integrated by upstream
	rm -f	"${WORKDIR}"/${PN}/0002-build-Add-major-version-to-make-parallel-installable.patch \
		"${WORKDIR}"/${PN}/0005-headers-Fix-symbols-visibility.patch \
		"${WORKDIR}"/${PN}/0007-build-Remove-unnecessary-NSPR-dependency.patch \
		|| die

	eapply "${WORKDIR}/${PN}"
	eapply "${FILESDIR}"/${PN}-52-baseconfig.patch

	eapply_user

	if [[ ${CHOST} == *-freebsd* ]]; then
		# Don't try to be smart, this does not work in cross-compile anyway
		ln -sfn "${BUILDDIR}/config/Linux_All.mk" "${S}/config/$(uname -s)$(uname -r).mk" || die
	fi

	cd "${BUILDDIR}" || die
	eautoconf old-configure.in
	eautoconf

	# there is a default config.cache that messes everything up
	rm -f "${BUILDDIR}"/config.cache || die
}

src_configure() {
	cd "${BUILDDIR}" || die

	econf \
		--enable-jemalloc \
		--enable-readline \
		--with-system-nspr \
		--disable-optimize \
		--with-intl-api \
		$(use_with system-icu) \
		$(use_enable debug) \
		$(use_enable jit ion) \
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

	if ! use minimal; then
		if use jit; then
			pax-mark m "${ED}"usr/bin/js${SLOT}
		fi
	else
		rm -f "${ED}"usr/bin/js${SLOT}
	fi

	# We can't actually disable building of static libraries
	# They're used by the tests and in a few other places
	find "${D}" -iname '*.a' -o -iname '*.ajs' -delete || die
}
