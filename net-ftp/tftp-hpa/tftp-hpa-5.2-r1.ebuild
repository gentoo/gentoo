# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit systemd eutils toolchain-funcs

DESCRIPTION="port of the OpenBSD TFTP server"
HOMEPAGE="https://www.kernel.org/pub/software/network/tftp/"
SRC_URI="https://www.kernel.org/pub/software/network/tftp/${PN}/${P}.tar.xz"

LICENSE="BSD-4"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~ppc-macos"
IUSE="ipv6 readline selinux tcpd"

CDEPEND="
	readline? ( sys-libs/readline:0= )
	tcpd? ( sys-apps/tcp-wrappers )
	!net-ftp/atftp
	!net-ftp/netkit-tftp"
DEPEND="${CDEPEND}
	app-arch/xz-utils"
RDEPEND="${CDEPEND}
	selinux? ( sec-policy/selinux-tftp )
"

src_prepare() {
	epatch "${FILESDIR}"/tftp-hpa-5.2-gcc-10.patch
	epatch_user

	sed -i "/^AR/s:ar:$(tc-getAR):" MCONFIG.in || die
}

src_configure() {
	econf \
		$(use_with ipv6) \
		$(use_with tcpd tcpwrappers) \
		$(use_with readline)
}

src_install() {
	emake INSTALLROOT="${D}" install
	dodoc README* CHANGES tftpd/sample.rules

	# iputils installs this
	rm "${ED}"/usr/share/man/man8/tftpd.8 || die

	newconfd "${FILESDIR}"/in.tftpd.confd-0.44 in.tftpd
	newinitd "${FILESDIR}"/in.tftpd.rc6 in.tftpd

	systemd_dounit "${FILESDIR}"/tftp.service
	systemd_dounit "${FILESDIR}"/tftp.socket

	insinto /etc/xinetd.d
	newins "${FILESDIR}"/tftp.xinetd tftp
}
