# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

# Patch version
FIREFOX_PATCHSET="firefox-78esr-patches-04.tar.xz"
SPIDERMONKEY_PATCHSET="spidermonkey-78-patches-02.tar.xz"

PYTHON_COMPAT=( python3_{6..9} )

WANT_AUTOCONF="2.1"

inherit autotools check-reqs flag-o-matic multiprocessing python-any-r1 toolchain-funcs

MY_PN="mozjs"
MY_PV="${PV/_pre*}" # Handle Gentoo pre-releases

MY_MAJOR=$(ver_cut 1)

MOZ_ESR=yes

MOZ_PV=${PV}
MOZ_PV_SUFFIX=
if [[ ${PV} =~ (_(alpha|beta|rc).*)$ ]] ; then
	MOZ_PV_SUFFIX=${BASH_REMATCH[1]}

	# Convert the ebuild version to the upstream Mozilla version
	MOZ_PV="${MOZ_PV/_alpha/a}" # Handle alpha for SRC_URI
	MOZ_PV="${MOZ_PV/_beta/b}"  # Handle beta for SRC_URI
	MOZ_PV="${MOZ_PV%%_rc*}"    # Handle rc for SRC_URI
fi

if [[ -n ${MOZ_ESR} ]] ; then
	# ESR releases have slightly different version numbers
	MOZ_PV="${MOZ_PV}esr"
fi

MOZ_PN="firefox"
MOZ_P="${MOZ_PN}-${MOZ_PV}"
MOZ_PV_DISTFILES="${MOZ_PV}${MOZ_PV_SUFFIX}"
MOZ_P_DISTFILES="${MOZ_PN}-${MOZ_PV_DISTFILES}"

MOZ_SRC_BASE_URI="https://archive.mozilla.org/pub/${MOZ_PN}/releases/${MOZ_PV}"

if [[ ${PV} == *_rc* ]] ; then
	MOZ_SRC_BASE_URI="https://archive.mozilla.org/pub/${MOZ_PN}/candidates/${MOZ_PV}-candidates/build${PV##*_rc}"
fi

PATCH_URIS=(
	https://dev.gentoo.org/~{whissi,polynomial-c,axs}/mozilla/patchsets/${FIREFOX_PATCHSET}
	https://dev.gentoo.org/~{whissi,polynomial-c,axs}/mozilla/patchsets/${SPIDERMONKEY_PATCHSET}
)

SRC_URI="${MOZ_SRC_BASE_URI}/source/${MOZ_P}.source.tar.xz -> ${MOZ_P_DISTFILES}.source.tar.xz
	${PATCH_URIS[@]}"

DESCRIPTION="SpiderMonkey is Mozilla's JavaScript engine written in C and C++"
HOMEPAGE="https://developer.mozilla.org/en-US/docs/Mozilla/Projects/SpiderMonkey"

KEYWORDS="amd64 ~arm arm64 ~mips ~ppc64 ~s390 x86"

SLOT="78"
LICENSE="MPL-2.0"
IUSE="cpu_flags_arm_neon debug +jit lto test"

RESTRICT="!test? ( test )"

BDEPEND="${PYTHON_DEPS}
	sys-devel/llvm
	>=virtual/rust-1.41.0
	virtual/pkgconfig"

CDEPEND=">=dev-libs/icu-67.1:=
	>=dev-libs/nspr-4.25
	sys-libs/readline:0=
	>=sys-libs/zlib-1.2.3"

DEPEND="${CDEPEND}
	test? (
		$(python_gen_any_dep 'dev-python/six[${PYTHON_USEDEP}]')
	)"

RDEPEND="${CDEPEND}"

S="${WORKDIR}/firefox-${MY_PV}/js/src"

python_check_deps() {
	if use test ; then
		has_version "dev-python/six[${PYTHON_USEDEP}]"
	fi
}

pkg_pretend() {
	if use test ; then
		CHECKREQS_DISK_BUILD="6400M"
	else
		CHECKREQS_DISK_BUILD="5600M"
	fi

	check-reqs_pkg_pretend
}

pkg_setup() {
	if use test ; then
		CHECKREQS_DISK_BUILD="6400M"
	else
		CHECKREQS_DISK_BUILD="5600M"
	fi

	check-reqs_pkg_setup

	python-any-r1_pkg_setup
}

src_prepare() {
	pushd ../.. &>/dev/null || die

	use lto && rm -v "${WORKDIR}"/firefox-patches/*-LTO-Only-enable-LTO-*.patch

	eapply "${WORKDIR}"/firefox-patches
	eapply "${WORKDIR}"/spidermonkey-patches

	default

	# Make LTO respect MAKEOPTS
	sed -i \
		-e "s/multiprocessing.cpu_count()/$(makeopts_jobs)/" \
		build/moz.configure/lto-pgo.configure \
		|| die "sed failed to set num_cores"

	# sed-in toolchain prefix
	sed -i \
		-e "s/objdump/${CHOST}-objdump/" \
		python/mozbuild/mozbuild/configure/check_debug_ranges.py \
		|| die "sed failed to set toolchain prefix"

	einfo "Removing pre-built binaries ..."
	find third_party -type f \( -name '*.so' -o -name '*.o' \) -print -delete || die

	MOZJS_BUILDDIR="${WORKDIR}/build"
	mkdir "${MOZJS_BUILDDIR}" || die

	popd &>/dev/null || die
	eautoconf
}

src_configure() {
	tc-export CC CXX LD AR RANLIB

	cd "${MOZJS_BUILDDIR}" || die

	# ../python/mach/mach/mixin/process.py fails to detect SHELL
	export SHELL="${EPREFIX}/bin/bash"

	local -a myeconfargs=(
		--host="${CBUILD:-${CHOST}}"
		--target="${CHOST}"
		--disable-jemalloc
		--disable-optimize
		--disable-strip
		--enable-readline
		--enable-shared-js
		--with-intl-api
		--with-system-icu
		--with-system-nspr
		--with-system-zlib
		--with-toolchain-prefix="${CHOST}-"
		$(use_enable debug)
		$(use_enable jit)
		$(use_enable test tests)
	)

	if ! use x86 && [[ ${CHOST} != armv*h* ]] ; then
		myeconfargs+=( --enable-rust-simd )
	fi

	# Modifications to better support ARM, bug 717344
	if use cpu_flags_arm_neon ; then
		myeconfargs+=( --with-fpu=neon )

		if ! tc-is-clang ; then
			# thumb options aren't supported when using clang, bug 666966
			myeconfargs+=( --with-thumb=yes )
			myeconfargs+=( --with-thumb-interwork=no )
		fi
	fi

	# Tell build system that we want to use LTO
	if use lto ; then
		myeconfargs+=( --enable-lto )
	fi

	# LTO flag was handled via configure
	filter-flags '-flto*'

	# Forcing system-icu allows us to skip patching bundled ICU for PPC
	# and other minor arches
	ECONF_SOURCE="${S}" \
		econf \
		${myeconfargs[@]} \
		XARGS="${EPREFIX}/usr/bin/xargs"
}

src_compile() {
	cd "${MOZJS_BUILDDIR}" || die
	default
}

src_test() {
	if "${MOZJS_BUILDDIR}/js/src/js" -e 'print("Hello world!")'; then
		einfo "Smoke-test successful, continuing with full test suite"
	else
		die "Smoke-test failed: did interpreter initialization fail?"
	fi

	local -a KNOWN_TESTFAILURES
	KNOWN_TESTFAILURES+=( non262/Date/reset-time-zone-cache-same-offset.js )
	KNOWN_TESTFAILURES+=( non262/Date/time-zone-path.js )
	KNOWN_TESTFAILURES+=( non262/Date/time-zones-historic.js )
	KNOWN_TESTFAILURES+=( non262/Date/time-zones-imported.js )
	KNOWN_TESTFAILURES+=( non262/Date/toString-localized.js )
	KNOWN_TESTFAILURES+=( non262/Date/toString-localized-posix.js )
	KNOWN_TESTFAILURES+=( non262/Intl/DateTimeFormat/timeZone_backward_links.js )
	KNOWN_TESTFAILURES+=( non262/Intl/DateTimeFormat/tz-environment-variable.js )
	KNOWN_TESTFAILURES+=( non262/Intl/Locale/likely-subtags.js )
	KNOWN_TESTFAILURES+=( test262/intl402/Locale/prototype/minimize/removing-likely-subtags-first-adds-likely-subtags.js )

	if use x86 ; then
		KNOWN_TESTFAILURES+=( non262/Date/timeclip.js )
		KNOWN_TESTFAILURES+=( test262/built-ins/Number/prototype/toPrecision/return-values.js )
		KNOWN_TESTFAILURES+=( test262/language/types/number/S8.5_A2.1.js )
		KNOWN_TESTFAILURES+=( test262/language/types/number/S8.5_A2.2.js )
	fi

	echo "" > "${T}"/known_failures.list || die

	local KNOWN_TESTFAILURE
	for KNOWN_TESTFAILURE in ${KNOWN_TESTFAILURES[@]} ; do
		echo "${KNOWN_TESTFAILURE}" >> "${T}"/known_failures.list
	done

	PYTHONPATH="${S}/tests/lib" \
		${PYTHON} \
		"${S}"/tests/jstests.py -d -s -t 1800 --wpt=disabled --no-progress \
		--exclude-file="${T}"/known_failures.list \
		"${MOZJS_BUILDDIR}"/js/src/js \
		|| die

	if use jit ; then
		KNOWN_TESTFAILURES=()

		echo "" > "${T}"/known_failures.list || die

		for KNOWN_TESTFAILURE in ${KNOWN_TESTFAILURES[@]} ; do
			echo "${KNOWN_TESTFAILURE}" >> "${T}"/known_failures.list
		done

		PYTHONPATH="${S}/tests/lib" \
			${PYTHON} \
			"${S}"/tests/jstests.py -d -s -t 1800 --wpt=disabled --no-progress \
			--exclude-file="${T}"/known_failures.list \
			"${MOZJS_BUILDDIR}"/js/src/js basic \
			|| die
	fi
}

src_install() {
	cd "${MOZJS_BUILDDIR}" || die
	default

	# fix soname links
	pushd "${ED}"/usr/$(get_libdir) &>/dev/null || die
	mv lib${MY_PN}-${MY_MAJOR}.so lib${MY_PN}-${MY_MAJOR}.so.0.0.0 || die
	ln -s lib${MY_PN}-${MY_MAJOR}.so.0.0.0 lib${MY_PN}-${MY_MAJOR}.so.0 || die
	ln -s lib${MY_PN}-${MY_MAJOR}.so.0 lib${MY_PN}-${MY_MAJOR}.so || die
	popd &>/dev/null || die

	# remove unneeded files
	rm \
		"${ED}"/usr/bin/js${MY_MAJOR}-config \
		"${ED}"/usr/$(get_libdir)/libjs_static.ajs \
		|| die

	# fix permissions
	chmod -x \
		"${ED}"/usr/$(get_libdir)/pkgconfig/*.pc \
		"${ED}"/usr/include/mozjs-${MY_MAJOR}/js-config.h \
		|| die
}
