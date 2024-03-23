# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools systemd tmpfiles

DESCRIPTION="GNU system accounting utilities"
HOMEPAGE="https://savannah.gnu.org/projects/acct/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="selinux"

RDEPEND="selinux? ( sec-policy/selinux-acct )"
BDEPEND="sys-apps/texinfo"

PATCHES=(
	"${FILESDIR}"/${PN}-6.6.4-cross-compile-fixed.patch
	"${FILESDIR}"/${PN}-6.6.4-fortify-source-3-sprintf-buffer-overflow.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf --enable-linux-multiformat
}

src_install() {
	default

	keepdir /var/account

	newinitd "${FILESDIR}"/acct.initd-r2 acct
	newconfd "${FILESDIR}"/acct.confd-r1 acct

	systemd_dounit "${FILESDIR}"/acct.service

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/acct.logrotate-r1 psacct

	# sys-apps/sysvinit already provides this
	rm "${ED}"/usr/bin/last "${ED}"/usr/share/man/man1/last.1 || die

	newtmpfiles "${FILESDIR}"/acct.tmpfiles acct.conf
}

pkg_postinst() {
	tmpfiles_process acct.conf
}
