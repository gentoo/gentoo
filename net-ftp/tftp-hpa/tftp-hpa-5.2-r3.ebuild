# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit systemd toolchain-funcs

DESCRIPTION="Port of the OpenBSD TFTP server"
HOMEPAGE="https://www.kernel.org/pub/software/network/tftp/"
SRC_URI="https://www.kernel.org/pub/software/network/tftp/${PN}/${P}.tar.xz"

LICENSE="BSD-4"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 ~s390 sparc x86 ~ppc-macos"
IUSE="ipv6 readline selinux tcpd +client +server"

DEPEND="
	readline? ( sys-libs/readline:0= )
	tcpd? ( sys-apps/tcp-wrappers )
"

RDEPEND="${DEPEND}
	selinux? ( sec-policy/selinux-tftp )
	!net-ftp/atftp
	server? (
		!net-misc/iputils[tftpd(-)]
		!net-ftp/uftpd
	)
"

PATCHES=(
	"${FILESDIR}"/tftp-hpa-5.2-gcc-10.patch
)

src_prepare() {
	default
	sed -i "/^AR/s:ar:$(tc-getAR):" MCONFIG.in || die
}

src_configure() {
	local myconf=(
		ac_cv_search_bsd_signal=no
		$(use_with ipv6)
		$(use_with tcpd tcpwrappers)
		$(use_with readline)
	)
	econf "${myconf[@]}"
}

src_compile() {
	emake version.h
	emake -C lib
	emake -C common
	if use client; then
		emake -C tftp
	fi
	if use server; then
		emake -C tftpd
	fi
}

src_install() {
	dodoc README* CHANGES tftpd/sample.rules

	if use client; then
		emake INSTALLROOT="${D}" -C tftp install
	fi
	if use server; then
		emake INSTALLROOT="${D}" -C tftpd install

		newconfd "${FILESDIR}"/in.tftpd.confd-0.44 in.tftpd
		newinitd "${FILESDIR}"/in.tftpd.rc6 in.tftpd

		systemd_dounit "${FILESDIR}"/tftp.service
		systemd_dounit "${FILESDIR}"/tftp.socket

		insinto /etc/xinetd.d
		newins "${FILESDIR}"/tftp.xinetd tftp
	fi
}
