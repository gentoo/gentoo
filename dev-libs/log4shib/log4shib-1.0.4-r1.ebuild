# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Internet2 version for OpenSAML of log4cpp logging framework"
HOMEPAGE="https://wiki.shibboleth.net/confluence/display/OpenSAML/log4shib"
SRC_URI="https://shibboleth.net/downloads/${PN}/${PV}/${P}.tar.gz"

KEYWORDS="~amd64 ~x86"
LICENSE="LGPL-2.1"
SLOT="0"
IUSE="debug doc static-libs"

BDEPEND="doc? ( app-doc/doxygen )"

src_configure() {
	econf --without-idsa \
		$(use_enable debug) \
		$(use_enable doc doxygen) \
		$(use_enable static-libs static)
}
