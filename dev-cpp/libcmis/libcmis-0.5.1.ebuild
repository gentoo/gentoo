# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

EGIT_REPO_URI="https://github.com/tdf/libcmis.git"
[[ ${PV} == 9999 ]] && SCM_ECLASS="git-r3"
inherit eutils alternatives autotools ${SCM_ECLASS}
unset SCM_ECLASS

DESCRIPTION="C++ client library for the CMIS interface"
HOMEPAGE="https://github.com/tdf/libcmis"
[[ ${PV} == 9999 ]] || SRC_URI="https://github.com/tdf/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="|| ( GPL-2 LGPL-2 MPL-1.1 )"
SLOT="0.5"

# Don't move KEYWORDS on the previous line or ekeyword won't work # 399061
[[ ${PV} == 9999 ]] || \
KEYWORDS="~amd64 ~arm ~x86 ~amd64-linux ~x86-linux"

IUSE="static-libs man test"

COMMON_DEPEND="
	dev-libs/boost:=
	dev-libs/libxml2
	net-misc/curl
"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
	>=sys-devel/boost-m4-0.4_p20160328
	man? (
		app-text/docbook2X
		dev-libs/libxslt
	)
	test? (
		dev-util/cppcheck
		dev-util/cppunit
	)
"
RDEPEND="${COMMON_DEPEND}
	!dev-cpp/libcmis:0
	!dev-cpp/libcmis:0.2
	!dev-cpp/libcmis:0.3
	!dev-cpp/libcmis:0.4
"

src_prepare() {
	default
	# fixes bug 569614, which is due to an outdated bundled boost.m4
	rm m4/boost.m4 || die

	eautoreconf
}

src_configure() {
	econf \
		--program-suffix=-${SLOT} \
		--disable-werror \
		$(use_with man) \
		$(use_enable static-libs static) \
		$(use_enable test tests) \
		--enable-client
}

src_install() {
	default
	prune_libtool_files --all
}

pkg_postinst() {
	alternatives_auto_makesym /usr/bin/cmis-client "/usr/bin/cmis-client-[0-9].[0-9]"
}

pkg_postrm() {
	alternatives_auto_makesym /usr/bin/cmis-client "/usr/bin/cmis-client-[0-9].[0-9]"
}
