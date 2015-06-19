# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/ldb/ldb-1.1.19.ebuild,v 1.3 2015/04/08 18:28:32 mgorny Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="threads"

inherit python-single-r1 waf-utils multilib

DESCRIPTION="An LDAP-like embedded database"
HOMEPAGE="http://ldb.samba.org"
SRC_URI="http://www.samba.org/ftp/pub/${PN}/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0/${PV}"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~x86 ~amd64-fbsd ~x86-fbsd"
IUSE="doc"

RDEPEND="dev-libs/popt
	>=sys-libs/talloc-2.1.1[python]
	>=sys-libs/tevent-0.9.22[python(+)]
	>=sys-libs/tdb-1.3.4[python]
	net-nds/openldap
	!!<net-fs/samba-3.6.0[ldb]
	!!>=net-fs/samba-4.0.0[ldb]
	${PYTHON_DEPS}
	"

DEPEND="dev-libs/libxslt
	doc? ( app-doc/doxygen )
	virtual/pkgconfig
	${RDEPEND}"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

WAF_BINARY="${S}/buildtools/bin/waf"

pkg_setup() {
	python-single-r1_pkg_setup
}

src_configure() {
	waf-utils_src_configure \
		--disable-rpath \
		--disable-rpath-install --bundled-libraries=NONE \
		--with-modulesdir="${EPREFIX}"/usr/$(get_libdir)/samba \
		--builtin-libraries=NONE
}

src_compile(){
	waf-utils_src_compile
	use doc && doxygen Doxyfile
}

src_test() {
	WAF_MAKE=1 \
	PATH=buildtools/bin:../../../buildtools/bin:$PATH:"${S}"/bin/shared/private/ \
	LD_LIBRARY_PATH=$LD_LIBRARY_PATH:"${S}"/bin/shared/private/:"${S}"/bin/shared waf test || die
}

src_install() {
	waf-utils_src_install

	if use doc; then
		dohtml -r apidocs/html/*
		doman  apidocs/man/man3/*.3
	fi
}

pkg_postinst() {
	if has_version sys-auth/sssd; then
		ewarn "You have sssd installed. It is known to break after ldb upgrades,"
		ewarn "so please try to rebuild it before reporting bugs."
		ewarn "See http://bugs.gentoo.org/404281"
	fi
}
