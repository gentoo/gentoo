# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{4,5,6} )

inherit cmake-utils gnome2-utils python-single-r1 xdg-utils

DESCRIPTION="A personal finance manager"
HOMEPAGE="http://www.gnucash.org/"
SRC_URI="https://github.com/Gnucash/${PN}/releases/download/${PV}/${P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

IUSE="aqbanking chipcard debug doc examples gnome-keyring +gui mysql nls ofx
	  postgres python quotes -register2 sqlite test"

REQUIRED_USE="
	chipcard? ( aqbanking )
	python? ( ${PYTHON_REQUIRED_USE} )"

# libdbi version requirement for sqlite taken from bug #455134
#
# dev-libs/boost must always be built with nls enabled.
# guile[deprecated] because of SCM_LIST*() use
RDEPEND="
	>=dev-libs/glib-2.46.0:2
	>=dev-libs/libxml2-2.7.0:2
	>=sys-libs/zlib-1.1.4
	>=dev-scheme/guile-2.2.0:12=[deprecated,regex]
	dev-libs/boost:=[icu,nls]
	dev-libs/icu:=
	dev-libs/libxslt
	aqbanking? (
		>=net-libs/aqbanking-5[gtk,ofx?]
		sys-libs/gwenhywfar[gtk]
		chipcard? ( sys-libs/libchipcard )
	)
	gnome-keyring? ( >=app-crypt/libsecret-0.18 )
	gui? (
		gnome-base/dconf
		net-libs/webkit-gtk:4=
		>=x11-libs/gtk+-3.14.0:3
	)
	mysql? (
		dev-db/libdbi
		dev-db/libdbi-drivers[mysql]
	)
	ofx? ( >=dev-libs/libofx-0.9.1 )
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
		>=dev-db/libdbi-0.9.0
		>=dev-db/libdbi-drivers-0.9.0[sqlite]
	)
"

DEPEND="${RDEPEND}
	>=sys-devel/gettext-0.19.6
	dev-lang/perl
	dev-perl/XML-Parser
	sys-devel/libtool
	virtual/pkgconfig
	test? ( >=dev-cpp/gtest-1.8.0 )
"

PDEPEND="doc? (
	~app-doc/gnucash-docs-${PV}
	gnome-extra/yelp
)"

PATCHES=(
	"${FILESDIR}"/${PN}-3.2-no-gui.patch
	"${FILESDIR}"/${PN}-3.7-include-checksymbolexists.patch
)

pkg_setup() {
	use python && python-single-r1_pkg_setup
	xdg_environment_reset
}

src_unpack() {
	default
	cp "${FILESDIR}"/gnucash-3.4-test-stress-options.scm \
	   ${PN}-${PV}/${PN}/report/standard-reports/test/test-stress-options.scm \
		|| die "Failed copying scm"
}

src_prepare() {
	cmake-utils_src_prepare

	# Fix tests writing to /tmp
	local fixtestfiles=(
		"${S}"/gnucash/report/report-system/test/test-commodity-utils.scm
		"${S}"/gnucash/report/report-system/test/test-extras.scm
		"${S}"/gnucash/report/report-system/test/test-report-html.scm
		"${S}"/gnucash/report/report-system/test/test-report-system.scm
		"${S}"/libgnucash/backend/xml/test/test-xml-pricedb.cpp
		"${S}"/libgnucash/backend/dbi/test/test-backend-dbi-basic.cpp
	)
	for x in "${fixtestfiles[@]}"; do
		sed -i -e "s|\"/tmp/|\"${T}/|g" "${x}" || die "sed of "${x}" failed"
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

	cmake-utils_src_configure
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
	XDG_DATA_HOME="${T}/$(whoami)" emake check
}

src_install() {
	cmake-utils_src_install

	rm "${ED%/}"/usr/share/doc/${PF}/README.dependencies || die

	if use examples ; then
		mv "${ED%/}"/usr/share/doc/gnucash \
		   "${ED%/}"/usr/share/doc/${PF}/examples || die
		pushd "${ED%/}"/usr/share/doc/${PF}/examples/ > /dev/null || die
		rm AUTHORS DOCUMENTERS LICENSE NEWS projects.html ChangeLog* \
		   *win32-bin.txt || die
		popd > /dev/null || die
		docompress -x /usr/share/doc/${PF}/examples/
	else
		rm -r "${ED%/}"/usr/share/doc/gnucash || die
	fi

	use aqbanking && dodoc doc/README.HBCI
	use ofx && dodoc doc/README.OFX
}

pkg_postinst() {
	if use gui ; then
		gnome2_icon_cache_update
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
		gnome2_icon_cache_update
		gnome2_schemas_update
	fi
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}
