# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/python-ldap/python-ldap-2.3.9.ebuild,v 1.20 2012/11/14 08:17:33 xarthisius Exp $

EAPI="3"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils multilib

DOC_P="${PN}-docs-html-${PV}"

DESCRIPTION="Various LDAP-related Python modules"
HOMEPAGE="http://www.python-ldap.org http://pypi.python.org/pypi/python-ldap"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz
	doc? ( http://dev.gentoo.org/~xarthisius/distfiles/${DOC_P}.tar.gz )"

LICENSE="PSF-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86"
IUSE="doc examples sasl ssl"

# If you need support for openldap-2.3.x, please use python-ldap-2.3.9.
# python team: Please do not remove python-ldap-2.3.9 from the tree.
RDEPEND=">=net-nds/openldap-2.3
	sasl? ( dev-libs/cyrus-sasl )"
DEPEND="${DEPEND}
	dev-python/setuptools"

DOCS="CHANGES README"
PYTHON_MODNAME="dsml.py ldapurl.py ldif.py ldap"

src_prepare() {
	# Note: we can't add /usr/lib and /usr/lib/sasl2 to library_dirs due to a bug in py2.4
	sed -e "s:^library_dirs =.*:library_dirs =:" \
		-e "s:^include_dirs =.*:include_dirs = /usr/include /usr/include/sasl:" \
		-e "s:\(extra_compile_args =\).*:\1\nextra_link_args = -Wl,-rpath=/usr/$(get_libdir) -Wl,-rpath=/usr/$(get_libdir)/sasl2:" \
		-i setup.cfg || die "error fixing setup.cfg"

	local mylibs="ldap"
	if use sasl; then
		use ssl && mylibs="ldap_r"
		mylibs="${mylibs} sasl2"
	fi
	use ssl && mylibs="${mylibs} ssl crypto"

	sed -e "s:^libs = .*:libs = lber resolv ${mylibs}:" \
		-e "s:^compile.*:compile = 0:" \
		-e "s:^optimize.*:optimize = 0:" \
		-i setup.cfg || die "error setting up libs in setup.cfg"
}

src_install() {
	distutils_src_install

	if use doc; then
		dohtml -r "${WORKDIR}/${DOC_P}"/* || die "dohtml failed"
	fi

	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r Demo || die "doins failed"
	fi
}
