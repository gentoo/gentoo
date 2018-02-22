# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# google{test,mock} version
GV="1.8.0"
PYTHON_COMPAT=( python2_7 )

inherit cmake-utils gnome2-utils python-single-r1 xdg-utils

DESCRIPTION="A personal finance manager"
HOMEPAGE="http://www.gnucash.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2
		 https://github.com/google/googletest/archive/release-${GV}.tar.gz -> gtest-${GV}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ~ppc ~ppc64 x86"

# Add doc back in for 3.0 and bump app-doc/gnucash-docs
IUSE="aqbanking chipcard debug examples gnome-keyring mysql nls ofx postgres
	  python quotes -register2 sqlite"
REQUIRED_USE="
	chipcard? ( aqbanking )
	python? ( ${PYTHON_REQUIRED_USE} )"

# libdbi version requirement for sqlite taken from bug #455134
#
# dev-libs/boost must always be built with nls enabled.
RDEPEND="
	>=dev-libs/glib-2.40.0:2
	>=dev-libs/libxml2-2.7.0:2
	>=dev-scheme/guile-2.0.0:12=[regex]
	>=sys-libs/zlib-1.1.4
	>=x11-libs/gtk+-3.14.0:3
	dev-libs/boost:=[icu,nls]
	dev-libs/icu:=
	dev-libs/libxslt
	gnome-base/dconf
	net-libs/webkit-gtk:4=
	aqbanking? (
		>=net-libs/aqbanking-5[gtk,ofx?]
		sys-libs/gwenhywfar[gtk]
		chipcard? ( sys-libs/libchipcard )
	)
	gnome-keyring? ( >=app-crypt/libsecret-0.18 )
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
	~dev-cpp/gtest-${GV}
	dev-lang/perl
	dev-perl/XML-Parser
	dev-util/intltool
	gnome-base/gnome-common
	sys-devel/libtool
	virtual/pkgconfig
"

# Uncomment for 3.0
# PDEPEND="doc? (
# 	~app-doc/gnucash-docs-${PV}
# 	gnome-extra/yelp
# )"

PATCHES=(
	"${FILESDIR}"/${P}-double_free.patch
	"${FILESDIR}"/${P}-fix-tests-for-32bit-platforms.patch
)

pkg_setup() {
	use python && python-single-r1_pkg_setup
	xdg_environment_reset
}

src_configure() {
	local sql_on_off="OFF"
	if use mysql || use postgres || use sqlite ; then
		sql_on_off="ON"
	fi

	local mycmakeargs=(
		-DGMOCK_ROOT="${WORKDIR}"/googletest-release-${GV}/googlemock
		-DGTEST_ROOT="${WORKDIR}"/googletest-release-${GV}/googletest

		-DDISABLE_NLS=$(usex !nls)
		-DENABLE_REGISTER2=$(usex register2)
		-DWITH_AQBANKING=$(usex aqbanking)
		-DWITH_OFX=$(usex ofx)
		-DWITH_PYTHON=$(usex python)
		-DWITH_SQL=${sql_on_off}
	)

	cmake-utils_src_configure
}

src_test() {
	if use python ; then
		cp common/test-core/unittest_support.py \
		   "${BUILD_DIR}"/common/test-core/ || die
	fi

	cd "${BUILD_DIR}" || die
	XDG_DATA_HOME="${T}/$(whoami)" emake check
}

src_install() {
	cmake-utils_src_install

	rm "${ED%/}"/usr/share/doc/${PF}/README.dependencies || die
	rm "${ED%/}"/usr/share/glib-2.0/schemas/gschemas.compiled || die

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
	gnome2_icon_cache_update
	gnome2_schemas_update
	xdg_desktop_database_update
	xdg_mimeinfo_database_update

	ewarn "Backup all financial files or databases before using GnuCash >=2.7.0!"
	ewarn
	ewarn "GnuCash 2.7.0 introduced large changes in its file format and database"
	ewarn "schema that WILL prevent you from reverting back to GnuCash 2.6."
}

pkg_postrm() {
	gnome2_icon_cache_update
	gnome2_schemas_update
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}
