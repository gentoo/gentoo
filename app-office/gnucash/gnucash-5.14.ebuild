# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GUILE_REQ_USE="regex"
GUILE_COMPAT=( 2-2 3-0 )
PYTHON_COMPAT=( python3_{11..14} )

inherit cmake flag-o-matic gnome2 guile-single python-single-r1 xdg

# Please bump with app-doc/gnucash-docs
DESCRIPTION="Personal finance manager"
HOMEPAGE="https://www.gnucash.org/"
SRC_URI="https://github.com/Gnucash/gnucash/releases/download/${PV}/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="aqbanking debug doc examples +gui keyring mysql nls ofx postgres python quotes smartcard sqlite test"
# Tests were previously restricted because guile would try to use installed,
# not just-built modules. See https://bugs.gnucash.org/show_bug.cgi?id=799159#c1.
# TODO: as of 5.10, the ebuild should handle this OK. If no issues come up,
# need to forward those findings (and tidy up the patch for) upstream.
RESTRICT="!test? ( test )"

# Examples doesn't build unless GUI is also built
REQUIRED_USE="
	${GUILE_REQUIRED_USE}
	examples? ( gui )
	python? ( ${PYTHON_REQUIRED_USE} )
	smartcard? ( aqbanking )
"

# dev-libs/boost must always be built with nls enabled.
# net-libs/aqbanking dropped gtk with v6. So, to simplify the
# dependency, we just rely on that.
RDEPEND="
	${GUILE_DEPS}
	>=dev-libs/glib-2.68.1:2
	>=virtual/zlib-1.1.4:=
	dev-libs/boost:=[icu,nls]
	>=dev-libs/icu-54.0:=
	dev-libs/libxml2:2=
	dev-libs/libxslt
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/pango
	aqbanking? (
		>=net-libs/aqbanking-6[ofx?]
		>=sys-libs/gwenhywfar-5.6.0:=
		smartcard? ( sys-libs/libchipcard )
	)
	gui? (
		>=x11-libs/gtk+-3.22.30:3
		gnome-base/dconf
		net-libs/webkit-gtk:4.1=
		aqbanking? ( sys-libs/gwenhywfar:=[gtk] )
	)
	keyring? (
		>=app-crypt/libsecret-0.18
	)
	mysql? (
		dev-db/libdbi
		dev-db/libdbi-drivers[mysql]
	)
	ofx? ( >=dev-libs/libofx-0.9.12:= )
	postgres? (
		dev-db/libdbi
		dev-db/libdbi-drivers[postgres]
	)
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			dev-python/pygobject:3[${PYTHON_USEDEP}]
		')
	)
	quotes? (
		>=dev-perl/Finance-Quote-1.11
		dev-perl/JSON-Parse
		dev-perl/HTML-TableExtract
	)
	sqlite? (
		dev-db/libdbi
		dev-db/libdbi-drivers[sqlite]
	)
"

# gtest is a required dep
# see https://bugs.gnucash.org/show_bug.cgi?id=795250
DEPEND="
	${RDEPEND}
	>=sys-devel/gettext-0.20
	dev-lang/perl
	dev-build/libtool
	>=dev-cpp/gtest-1.8.0
"
# distutils is not available in python3.12, but it is still in setuptools
BDEPEND="
	dev-lang/swig
	>=dev-build/cmake-3.10
	dev-libs/libxslt
	virtual/pkgconfig
	python? (
		$(python_gen_cond_dep '
			dev-python/setuptools[${PYTHON_USEDEP}]
		')
	)
"

PDEPEND="
	doc? (
		~app-doc/gnucash-docs-${PV}
		gnome-extra/yelp
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-5.0-exclude-license.patch"
	"${FILESDIR}/${PN}-5.6-no-werror.patch"
	# This is only to prevent webkit2gtk-4 from being selected.
	# https://bugs.gentoo.org/893676
	"${FILESDIR}/${PN}-5.0-webkit2gtk-4.1.patch"
	"${FILESDIR}/${PN}-5.14-guile-load-path.patch"
	"${FILESDIR}/${PN}-5.12-libsecret-build-option.patch"
)

pkg_setup() {
	guile-single_pkg_setup
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	cmake_src_prepare
	guile_bump_sources

	# ODR violation in libgnucash/engine/test/utest-Account.cpp and libgnucash/engine/test/utest-Split.cpp
	# with Fixture struct
	use test && filter-lto

	# Fix tests writing to /tmp
	local fixtestfiles=(
		bindings/python/example_scripts/simple_session.py
		bindings/python/sqlite3test.c
		bindings/python/example_scripts/simple_test.py
		gnucash/report/test/test-report-html.scm
		gnucash/report/test/test-report-extras.scm
		libgnucash/backend/dbi/test/test-backend-dbi-basic.cpp
	)
	local x
	for x in "${fixtestfiles[@]}"; do
		sed -i -e "s|\"/tmp/|\"${T}/|g" "${S}/${x}" || die "sed of ${S}/${x} failed"
	done

	# Skip test that appears to be fickle in the ebuild env
	sed -e '/add_core_utils_test(test-userdata-dir-invalid-home test-userdata-dir-invalid-home.c)/d' \
		-i libgnucash/core-utils/test/CMakeLists.txt || die
}

src_configure() {
	# Used in src_test but the value has to be available at `cmake`
	# generation time.
	export GENTOO_TEMPORARY_TEST_INSTALLDIR="${BUILD_DIR}/test_install"

	local sql_on_off="OFF"
	if use mysql || use postgres || use sqlite ; then
		sql_on_off="ON"
	fi

	local mycmakeargs=(
		-DCOMPILE_GSCHEMAS=OFF
		-DDISABLE_NLS=$(usex !nls)
		-DWITH_AQBANKING=$(usex aqbanking)
		-DWITH_GNUCASH=$(usex gui)
		-DWITH_OFX=$(usex ofx)
		-DWITH_PYTHON=$(usex python)
		-DWITH_SQL=${sql_on_off}
		-DWITH_LIBSECRET=$(usex keyring)
	)

	cmake_src_configure
}

src_test() {
	LOCALE_TESTS=
	if type locale >/dev/null 2>&1; then
		MY_LOCALES="$(locale -a)"
		if [[ "${MY_LOCALES}" != *en_US* ||
				"${MY_LOCALES}" != *en_GB* ||
				"${MY_LOCALES}" != *fr_FR* ]] ; then
			ewarn "Missing one or more of en_US, en_GB, or fr_FR locales."
		else
			LOCALE_TESTS=true
		fi
	else
		ewarn "'locale' not found."
	fi

	if [[ ! "${LOCALE_TESTS}" ]]; then
		ewarn "Disabling test-qof and test-gnc-numeric."
		echo 'set(CTEST_CUSTOM_TESTS_IGNORE test-qof test-gnc-numeric)' \
			> "${BUILD_DIR}"/CTestCustom.cmake || die "Failed to disable test-qof and test-gnc-numeric!"
	fi

	cd "${BUILD_DIR}" || die "Failed to enter ${BUILD_DIR}"

	# We need e.g. `options.scm` to be available for loading by tests
	# and the compiled `options.go` isn't enough. Do a temporary install
	# for the benefit of the testsuite.
	DESTDIR="${GENTOO_TEMPORARY_TEST_INSTALLDIR}" cmake_build install
	# This is needed for `load-path` to be correct, as it lacks `/usr` in there.
	local dir
	for dir in bin include "$(get_libdir)" share ; do
		ln -s "${GENTOO_TEMPORARY_TEST_INSTALLDIR}/usr/${dir}" "${GENTOO_TEMPORARY_TEST_INSTALLDIR}/${dir}" || die
	done

	# Avoid cmake_src_test as we don't get the test binaries built first
	# and get various failures as a result. Copy what upstream do in CI.
	eninja check
}

src_install() {
	cmake_src_install
	guile_unstrip_ccache

	use examples && docompress -x /usr/share/doc/${PF}/examples

	if use python ; then
		python_optimize
		python_optimize "${ED}"/usr/share/gnucash/python
	fi
}

pkg_preinst() {
	gnome2_pkg_preinst
	xdg_pkg_preinst
}

pkg_postinst() {
	gnome2_pkg_postinst
	xdg_pkg_postinst
}

pkg_postrm() {
	gnome2_pkg_postrm
	xdg_pkg_postrm
}
