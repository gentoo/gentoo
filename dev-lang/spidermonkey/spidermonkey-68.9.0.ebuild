# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PYTHON_COMPAT=( python3_{6..8} )

WANT_AUTOCONF="2.1"

inherit autotools check-reqs python-any-r1

MY_PN="mozjs"
MY_PV="${PV/_pre*}" # Handle Gentoo pre-releases

MY_MAJOR=$(ver_cut 1)

MOZ_ESR="1"

# Convert the ebuild version to the upstream mozilla version
MOZ_PV="${MY_PV/_alpha/a}" # Handle alpha for SRC_URI
MOZ_PV="${MOZ_PV/_beta/b}" # Handle beta for SRC_URI
MOZ_PV="${MOZ_PV%%_rc*}" # Handle rc for SRC_URI

if [[ ${MOZ_ESR} == 1 ]] ; then
	# ESR releases have slightly different version numbers
	MOZ_PV="${MOZ_PV}esr"
fi

# Patch version
FIREFOX_PATCHSET="firefox-68.0-patches-14"
SPIDERMONKEY_PATCHSET="${PN}-68.6.0-patches-03"

MOZ_HTTP_URI="https://archive.mozilla.org/pub/firefox/releases"
MOZ_SRC_URI="${MOZ_HTTP_URI}/${MOZ_PV}/source/firefox-${MOZ_PV}.source.tar.xz"

if [[ "${PV}" == *_rc* ]]; then
	MOZ_HTTP_URI="https://archive.mozilla.org/pub/firefox/candidates/${MOZ_PV}-candidates/build${PV##*_rc}"
	MOZ_SRC_URI="${MOZ_HTTP_URI}/source/firefox-${MOZ_PV}.source.tar.xz"
fi

PATCH_URIS=(
	https://dev.gentoo.org/~{anarchy,whissi,polynomial-c,axs}/mozilla/patchsets/${FIREFOX_PATCHSET}.tar.xz
	https://dev.gentoo.org/~{whissi,polynomial-c,axs}/mozilla/patchsets/${SPIDERMONKEY_PATCHSET}.tar.xz
)

SRC_URI="${MOZ_SRC_URI}
	${PATCH_URIS[@]}"

DESCRIPTION="SpiderMonkey is Mozilla's JavaScript engine written in C and C++"
HOMEPAGE="https://developer.mozilla.org/en-US/docs/Mozilla/Projects/SpiderMonkey"

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"

SLOT="68"
LICENSE="MPL-2.0"
IUSE="debug +jit test"

RESTRICT="!test? ( test )"

BDEPEND="dev-lang/python:2.7
	test? ( ${PYTHON_DEPS} )"

DEPEND=">=dev-libs/icu-63.1:=
	>=dev-libs/nspr-4.21
	sys-libs/readline:0=
	>=sys-libs/zlib-1.2.3"
RDEPEND="${DEPEND}"

S="${WORKDIR}/firefox-${MY_PV}/js/src"

pkg_pretend() {
	if use test ; then
		CHECKREQS_DISK_BUILD="6G"
	else
		CHECKREQS_DISK_BUILD="5G"
	fi

	check-reqs_pkg_pretend
}

pkg_setup() {
	if use test ; then
		CHECKREQS_DISK_BUILD="6G"
	else
		CHECKREQS_DISK_BUILD="5G"
	fi

	check-reqs_pkg_setup

	use test && python-any-r1_pkg_setup
}

src_prepare() {
	cd ../.. || die
	rm "${WORKDIR}"/firefox/2013_avoid_noinline_on_GCC_with_skcms.patch
	rm "${WORKDIR}"/firefox/2015_fix_cssparser.patch
	eapply "${WORKDIR}"/firefox
	eapply "${WORKDIR}"/spidermonkey-patches

	default

	MOZJS_BUILDDIR="${WORKDIR}/build"
	mkdir "${MOZJS_BUILDDIR}" || die

	cd "${S}" || die
	eautoconf
}

src_configure() {
	tc-export CC CXX LD AR RANLIB

	# backup current active Python version
	local PYTHON_OLD=${PYTHON}

	# build system will require Python2.7
	export PYTHON=python2.7

	cd "${MOZJS_BUILDDIR}" || die

	# ../python/mach/mach/mixin/process.py fails to detect SHELL
	export SHELL="${EPREFIX}/bin/bash"

	# forcing system-icu allows us to skip patching bundled ICU for PPC
	# and other minor arches
	ECONF_SOURCE="${S}" \
	econf \
		--disable-jemalloc \
		--disable-optimize \
		--disable-strip \
		--enable-readline \
		--enable-shared-js \
		--with-intl-api \
		--with-system-icu \
		--with-system-nspr \
		--with-system-zlib \
		$(use_enable debug) \
		$(use_enable jit ion) \
		$(use_enable test tests) \
		XARGS="${EPREFIX}/usr/bin/xargs"

	# restore PYTHON
	export PYTHON=${PYTHON_OLD}
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
	KNOWN_TESTFAILURES+=( test262/intl402/RelativeTimeFormat/prototype/format/en-us-numeric-auto.js )
	KNOWN_TESTFAILURES+=( non262/Intl/DateTimeFormat/tz-environment-variable.js )
	KNOWN_TESTFAILURES+=( non262/Intl/RelativeTimeFormat/format.js )
	KNOWN_TESTFAILURES+=( non262/Date/time-zones-imported.js )
	KNOWN_TESTFAILURES+=( non262/Date/toString-localized.js )
	KNOWN_TESTFAILURES+=( non262/Date/time-zone-path.js )
	KNOWN_TESTFAILURES+=( non262/Date/time-zones-historic.js )
	KNOWN_TESTFAILURES+=( non262/Date/toString-localized-posix.js )
	KNOWN_TESTFAILURES+=( non262/Date/reset-time-zone-cache-same-offset.js )

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
