# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools

MY_P=apache-${P}

DESCRIPTION="Library of C++ classes for logging to files, syslog and other destinations"
HOMEPAGE="https://logging.apache.org/log4cxx/"
SRC_URI="mirror://apache/logging/${PN}/${PV}/${MY_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~x86 ~amd64-linux ~ppc-macos"
IUSE="iodbc unicode odbc smtp"
REQUIRED_USE="iodbc? ( !odbc )"
# test suite fails
RESTRICT="test"

RDEPEND="
	dev-libs/apr:1=
	dev-libs/apr-util:1=
	odbc? (
		iodbc? ( >=dev-db/libiodbc-3.52.4 )
		!iodbc? ( dev-db/unixODBC )
	)
	smtp? ( net-libs/libesmtp )"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--disable-static \
		--disable-doxygen \
		--disable-html-docs \
		--with-apr-util="${ESYSROOT}"/usr \
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
	find "${ED}" -name '*.la' -delete || die
}
