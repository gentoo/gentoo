# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit cmake gnome2-utils python-single-r1 toolchain-funcs xdg-utils

DESCRIPTION="A personal finance manager"
HOMEPAGE="https://www.gnucash.org/"
SRC_URI="https://github.com/Gnucash/${PN}/releases/download/${PV}/${P}.tar.bz2"
SRC_URI+=" https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${P}-Fix-build-with-glib-2.68.patch.xz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ~arm64 ~ppc ~ppc64 x86"

IUSE="aqbanking debug doc examples gnome-keyring +gui mysql nls ofx postgres
	  python quotes register2 smartcard sqlite test"
RESTRICT="!test? ( test )"

# Examples doesn't build unless GUI is also built
REQUIRED_USE="
	examples? ( gui )
	python? ( ${PYTHON_REQUIRED_USE} )
	smartcard? ( aqbanking )"

# dev-libs/boost must always be built with nls enabled.
# net-libs/aqbanking dropped gtk with v6. So, to simplify the
#   dependency, we just rely on that.
RDEPEND="
	>=dev-libs/glib-2.56.1:2
	>=dev-scheme/guile-2.2.0:=[regex]
	>=sys-libs/zlib-1.1.4
	dev-libs/boost:=[icu,nls]
	dev-libs/icu:=
	dev-libs/libxml2:2
	dev-libs/libxslt
	aqbanking? (
		>=net-libs/aqbanking-6[ofx?]
		sys-libs/gwenhywfar:=
		smartcard? ( sys-libs/libchipcard )
	)
	gnome-keyring? ( >=app-crypt/libsecret-0.18 )
	gui? (
		>=x11-libs/gtk+-3.22.30:3
		gnome-base/dconf
		net-libs/webkit-gtk:4=
		aqbanking? ( sys-libs/gwenhywfar:=[gtk] )
	)
	mysql? (
		dev-db/libdbi
		dev-db/libdbi-drivers[mysql]
	)
	ofx? ( >=dev-libs/libofx-0.9.1:= )
	postgres? (
		dev-db/libdbi
		dev-db/libdbi-drivers[postgres]
	)
	python? ( ${PYTHON_DEPS} )
	quotes? (
		>=dev-perl/Finance-Quote-1.11
		dev-perl/Date-Manip
		dev-perl/HTML-TableExtract
	)
	sqlite? (
		dev-db/libdbi
		dev-db/libdbi-drivers[sqlite]
	)
"

DEPEND="${RDEPEND}
	>=dev-cpp/gtest-1.8.0
	>=sys-devel/gettext-0.20
	dev-lang/perl
	dev-perl/XML-Parser
	sys-devel/libtool
"

BDEPEND="
	dev-lang/swig
	dev-util/cmake
	virtual/pkgconfig
"

PDEPEND="doc? (
	~app-doc/gnucash-docs-${PV}
	gnome-extra/yelp
)"

PATCHES=(
	"${FILESDIR}"/${PN}-3.2-no-gui.patch
	"${FILESDIR}"/${PN}-3.8-examples-subdir.patch
	"${FILESDIR}"/${PN}-3.8-exclude-license.patch
	"${WORKDIR}"/${P}-Fix-build-with-glib-2.68.patch
)

S="${WORKDIR}/${PN}-$(ver_cut 1-2)"

pkg_setup() {
	use python && python-single-r1_pkg_setup
	xdg_environment_reset
}

src_prepare() {
	cmake_src_prepare

	# Fix tests writing to /tmp
	local fixtestfiles=(
		gnucash/report/test/test-report-html.scm
		gnucash/report/reports/standard/test/test-invoice.scm
		gnucash/report/reports/standard/test/test-new-owner-report.scm
		gnucash/report/reports/standard/test/test-owner-report.scm
		gnucash/report/reports/standard/test/test-transaction.scm
		gnucash/report/reports/standard/test/test-portfolios.scm
		gnucash/report/reports/standard/test/test-charts.scm
		gnucash/report/test/test-report.scm
		gnucash/report/test/test-commodity-utils.scm
		gnucash/report/test/test-report-extras.scm
		libgnucash/backend/dbi/test/test-backend-dbi-basic.cpp
		libgnucash/backend/xml/test/test-xml-pricedb.cpp
	)
	for x in "${fixtestfiles[@]}"; do
		sed -i -e "s|\"/tmp/|\"${T}/|g" "${S}/${x}" || die "sed of "${S}/${x}" failed"
	done
}

src_configure() {
	export GUILE_AUTO_COMPILE=0

	local sql_on_off="OFF"
	if use mysql || use postgres || use sqlite ; then
		sql_on_off="ON"
	fi

	local mycmakeargs=(
		-DCOMPILE_GSCHEMAS=OFF
		-DDISABLE_NLS=$(usex !nls)
		-DENABLE_REGISTER2=$(usex register2)
		-DWITH_AQBANKING=$(usex aqbanking)
		-DWITH_OFX=$(usex ofx)
		-DWITH_PYTHON=$(usex python)
		-DWITH_SQL=${sql_on_off}
		-DWITH_GNUCASH=$(usex gui)
	)

	cmake_src_configure
}

src_test() {
	if use python ; then
		cp common/test-core/unittest_support.py \
		   "${BUILD_DIR}"/common/test-core/ || die
	fi

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

	if [[ ! ${LOCALE_TESTS} ]]; then
		ewarn "Disabling test-qof and test-gnc-numeric."
		echo 'set(CTEST_CUSTOM_TESTS_IGNORE test-qof test-gnc-numeric)' \
			> "${BUILD_DIR}"/CTestCustom.cmake || die
	fi

	cd "${BUILD_DIR}" || die
	XDG_DATA_HOME="${T}/$(whoami)" eninja check
}

src_install() {
	cmake_src_install

	# strip is unable to recognise the format of the input files (*.go)
	dostrip -x /usr/$(get_libdir)/guile

	if use examples ; then
		docompress -x /usr/share/doc/${PF}/examples
	else
		rm -r "${ED}"/usr/share/doc/${PF}/examples
	fi

	if use python ; then
		python_optimize
		python_optimize "${ED}"/usr/share/gnucash/python
	fi
}

pkg_postinst() {
	if use gui ; then
		xdg_icon_cache_update
		gnome2_schemas_update
	fi
	xdg_desktop_database_update
	xdg_mimeinfo_database_update

	ewarn "Backup all financial files or databases before using GnuCash >=2.7.0!"
	ewarn
	ewarn "GnuCash 2.7.0 introduced large changes in its file format and database"
	ewarn "schema that WILL prevent you from reverting back to GnuCash 2.6."
}

pkg_postrm() {
	if use gui ; then
		xdg_icon_cache_update
		gnome2_schemas_update
	fi
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}
