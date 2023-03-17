# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Please bump with app-doc/gnucash-docs

PYTHON_COMPAT=( python3_{9..11} )

inherit cmake gnome2-utils python-single-r1 xdg-utils

DESCRIPTION="A personal finance manager"
HOMEPAGE="https://www.gnucash.org/"
SRC_URI="https://github.com/Gnucash/gnucash/releases/download/${PV}/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc ~ppc64 ~riscv ~x86"

IUSE="aqbanking debug doc examples gnome-keyring +gui mysql nls ofx postgres python quotes register2 smartcard sqlite test"
RESTRICT="!test? ( test )"

# Examples doesn't build unless GUI is also built
REQUIRED_USE="
	examples? ( gui )
	python? ( ${PYTHON_REQUIRED_USE} )
	smartcard? ( aqbanking )
"

# dev-libs/boost must always be built with nls enabled.
# net-libs/aqbanking dropped gtk with v6. So, to simplify the
# dependency, we just rely on that.
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
		>=sys-libs/gwenhywfar-4.20.0:=
		smartcard? ( sys-libs/libchipcard )
	)
	gnome-keyring? ( >=app-crypt/libsecret-0.18 )
	gui? (
		>=x11-libs/gtk+-3.22.30:3
		gnome-base/dconf
		net-libs/webkit-gtk:4.1=
		aqbanking? ( sys-libs/gwenhywfar:=[gtk] )
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
			dev-python/pygobject[${PYTHON_USEDEP}]
		')
	)
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

# gtest is a required dep
# see https://bugs.gnucash.org/show_bug.cgi?id=795250
DEPEND="
	${RDEPEND}
	>=sys-devel/gettext-0.20
	dev-lang/perl
	dev-perl/XML-Parser
	sys-devel/libtool
	>=dev-cpp/gtest-1.8.0
"
BDEPEND="
	dev-lang/swig
	>=dev-util/cmake-3.10
	virtual/pkgconfig
"
PDEPEND="
	doc? (
		~app-doc/gnucash-docs-${PV}
		gnome-extra/yelp
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-3.8-exclude-license.patch"
	"${FILESDIR}/${PN}-4.12-drop-broken-test.patch"
	"${FILESDIR}/${PN}-4.13-no-werror.patch"

	# This is only to prevent webkit2gtk-4 from being selected.
	# https://bugs.gentoo.org/893676
	"${FILESDIR}/${P}-webkit2gtk-4.1.patch"
)

# guile generates ELF files without use of C or machine code
# It's a portage false positive, bug #677600
QA_PREBUILT='*[.]go'

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	cmake_src_prepare

	# http://debbugs.gnu.org/cgi/bugreport.cgi?bug=38112
	find "${S}" -name "*.scm" -exec touch {} + || die

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
		sed -i -e "s|\"/tmp/|\"${T}/|g" "${S}/${x}" || die "sed of ${S}/${x} failed"
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
	XDG_DATA_HOME="${T}/$(whoami)" eninja check
	cmake_src_test
}

src_install() {
	cmake_src_install

	dostrip -x /usr/$(get_libdir)/guile/2.2/site-ccache/gnucash/

	use examples && docompress -x /usr/share/doc/${PF}/examples

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
}

pkg_postrm() {
	if use gui ; then
		xdg_icon_cache_update
		gnome2_schemas_update
	fi
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}
