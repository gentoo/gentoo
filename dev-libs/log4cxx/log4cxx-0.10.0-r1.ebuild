# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

MY_P=apache-${P}

DESCRIPTION="Library of C++ classes for logging to files, syslog and other destinations"
HOMEPAGE="http://logging.apache.org/log4cxx/"
SRC_URI="mirror://apache/logging/${PN}/${PV}/${MY_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~x86 ~amd64-linux ~ppc-macos"
IUSE="iodbc unicode odbc smtp"

RDEPEND="dev-libs/apr:1
	dev-libs/apr-util:1
	odbc? (
		iodbc? ( >=dev-db/libiodbc-3.52.4 )
		!iodbc? ( dev-db/unixODBC ) )
	smtp? ( net-libs/libesmtp )"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

# test suite fails
RESTRICT="test"

HTML_DOCS=( site/. )
PATCHES=(
	"${FILESDIR}/${PN}-0.10.0-missing_includes.patch"
	"${FILESDIR}/${PN}-0.10.0-gcc44.patch"
	"${FILESDIR}/${PN}-0.10.0-unixODBC.patch"
	"${FILESDIR}/${PN}-0.10.0-fix-c++14.patch"
)

pkg_setup() {
	if use iodbc && ! use odbc; then
		elog "Please enable the odbc USE-flag as well if you want odbc-support through iodbc."
	fi
}

src_configure() {
	econf \
		--disable-doxygen \
		--disable-html-docs \
		--with-apr-util="${SYSROOT:-${EPREFIX}}/usr" \
		$(use_with smtp SMTP libesmtp) \
		$(use_with odbc ODBC $(usex iodbc iODBC unixODBC)) \
		--with-charset=$(usex unicode utf-8 auto)
}

src_install() {
	default

	docinto examples
	dodoc src/examples/cpp/*.cpp
	docompress -x /usr/share/doc/${PF}/examples

	# package provides .pc files
	find "${D}" -name '*.la' -delete || die
}
