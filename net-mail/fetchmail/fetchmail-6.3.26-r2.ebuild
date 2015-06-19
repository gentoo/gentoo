# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/fetchmail/fetchmail-6.3.26-r2.ebuild,v 1.11 2015/04/08 18:18:33 mgorny Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="tk"

inherit python-single-r1 user systemd toolchain-funcs autotools eutils

DESCRIPTION="the legendary remote-mail retrieval and forwarding utility"
HOMEPAGE="http://www.fetchmail.info/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.xz"

LICENSE="GPL-2 public-domain"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="ssl nls kerberos hesiod tk socks"
REQUIRED_USE="tk? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="hesiod? ( net-dns/hesiod )
	ssl? ( >=dev-libs/openssl-0.9.6 )
	kerberos? ( virtual/krb5 >=dev-libs/openssl-0.9.6 )
	nls? ( virtual/libintl )
	!elibc_glibc? ( sys-libs/e2fsprogs-libs )
	socks? ( net-proxy/dante )
	tk? ( ${PYTHON_DEPS} )"
DEPEND="${RDEPEND}
	app-arch/xz-utils
	sys-devel/flex
	nls? ( sys-devel/gettext )"

DOCS="FAQ FEATURES NEWS NOTES README README.NTLM README.SSL* TODO"

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 /var/lib/${PN} ${PN}

	use tk && python-single-r1_pkg_setup
}

src_prepare() {
	# don't compile during src_install
	use tk && : > "${S}"/py-compile

	epatch "${FILESDIR}"/${P}-python-optional.patch
	epatch "${FILESDIR}"/${P}-tests.patch
	eautoreconf
}

src_configure() {
	use tk || export PYTHON=:

	econf \
		--enable-RPA \
		--enable-NTLM \
		--enable-SDPS \
		$(use_enable nls) \
		$(use_with ssl ssl "${EPREFIX}/usr") \
		$(use kerberos && echo "--with-ssl=${EPREFIX}/usr") \
		$(use_with kerberos gssapi) \
		$(use_with kerberos kerberos5) \
		$(use_with hesiod) \
		$(use_with socks)
}

src_compile() {
	emake AR="$(tc-getAR)"
}

src_install() {
	# fetchmail's homedir (holds fetchmail's .fetchids)
	keepdir /var/lib/${PN}
	fowners ${PN}:${PN} /var/lib/${PN}
	fperms 700 /var/lib/${PN}

	default

	dohtml *.html

	newinitd "${FILESDIR}"/fetchmail.initd fetchmail
	newconfd "${FILESDIR}"/fetchmail.confd fetchmail
	systemd_dounit "${FILESDIR}"/${PN}.service
	systemd_dotmpfilesd "${FILESDIR}"/${PN}.conf

	docinto contrib
	local f
	for f in contrib/* ; do
		[ -f "${f}" ] && dodoc "${f}"
	done

	use tk && python_optimize
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		elog "Please see /etc/conf.d/fetchmail if you want to adjust"
		elog "the polling delay used by the fetchmail init script."
	fi
}
