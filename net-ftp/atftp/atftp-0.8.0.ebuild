# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools flag-o-matic systemd

DESCRIPTION="Advanced TFTP implementation client/server"
HOMEPAGE="https://sourceforge.net/projects/atftp/"
SRC_URI="mirror://sourceforge/atftp/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="selinux tcpd readline pcre"

DEPEND="tcpd? ( sys-apps/tcp-wrappers )
	readline? ( sys-libs/readline:0= )
	pcre? ( dev-libs/libpcre2:= )"
RDEPEND="${DEPEND}
	!net-ftp/tftp-hpa
	!net-ftp/uftpd
	selinux? ( sec-policy/selinux-tftp )"
BDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-0.7.5-CFLAGS.patch"
	"${FILESDIR}/atftp-fix-test.patch"
)

src_prepare() {
	append-cppflags -D_REENTRANT -DRATE_CONTROL
	# fix #561720 by restoring pre-GCC5 inline semantics
	append-cflags -std=gnu89

	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable tcpd libwrap) \
		$(use_enable readline libreadline) \
		$(use_enable pcre libpcre) \
		--enable-mtftp
}

src_install() {
	default

	newinitd "${FILESDIR}"/atftp.init atftp
	newconfd "${FILESDIR}"/atftp.confd atftp

	systemd_dounit "${FILESDIR}"/atftp.service
	systemd_install_serviced "${FILESDIR}"/atftp.service.conf

	dodoc README* BUGS FAQ Changelog INSTALL TODO
	dodoc "${S}"/docs/*

	docinto test
	cd "${S}"/test || die
	dodoc load.sh mtftp.conf pcre_pattern.txt test.sh test_suite.txt
}
