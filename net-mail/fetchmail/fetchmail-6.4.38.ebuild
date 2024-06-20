# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools systemd tmpfiles toolchain-funcs

DESCRIPTION="the legendary remote-mail retrieval and forwarding utility"
HOMEPAGE="https://www.fetchmail.info/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.xz"

LICENSE="GPL-2 public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-solaris"
IUSE="ssl nls kerberos tk selinux socks"

RDEPEND="acct-user/fetchmail
	ssl? ( >=dev-libs/openssl-3.0.9:= )
	kerberos? ( virtual/krb5 )
	nls? ( virtual/libintl )
	!elibc_glibc? ( sys-fs/e2fsprogs )
	socks? ( net-proxy/dante )"
DEPEND="${RDEPEND}
	app-arch/xz-utils
	app-alternatives/lex
	nls? ( sys-devel/gettext )"
RDEPEND+=" selinux? ( sec-policy/selinux-fetchmail )"

REQUIRED_USE="kerberos? ( ssl )"

DOCS="FAQ FEATURES NEWS NOTES README README.NTLM README.SSL* TODO"
HTML_DOCS="*.html"
PATCHES=(
	"${FILESDIR}"/${PN}-6.3.26-python-optional.patch
)
S=${WORKDIR}/${P/_/.}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	export PYTHON=:

	econf \
		--enable-RPA \
		--enable-NTLM \
		--enable-SDPS \
		$(use_enable nls) \
		$(use_with ssl ssl "${EPREFIX}/usr") \
		$(use_with kerberos gssapi) \
		$(use_with kerberos kerberos5) \
		--without-hesiod \
		$(use_with socks)
}

src_compile() {
	emake AR="$(tc-getAR)"
}

src_install() {
	default

	newinitd "${FILESDIR}"/fetchmail.initd fetchmail
	newconfd "${FILESDIR}"/fetchmail.confd fetchmail

	systemd_dounit  "${FILESDIR}"/${PN}.service
	systemd_newunit "${FILESDIR}"/${PN}_at.service "${PN}@.service"
	dotmpfiles "${FILESDIR}"/${PN}.conf

	docinto contrib
	local f
	for f in contrib/* ; do
		[ -f "${f}" ] && dodoc "${f}"
	done
}

pkg_postinst() {
	tmpfiles_process ${PN}.conf

	if [[ -z ${REPLACING_VERSIONS} ]]; then
		elog "Please see /etc/conf.d/fetchmail if you want to adjust"
		elog "the polling delay used by the fetchmail init script."
	fi
}
