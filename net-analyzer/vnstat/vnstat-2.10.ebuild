# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd tmpfiles

DESCRIPTION="Console-based network traffic monitor that keeps statistics of network usage"
HOMEPAGE="https://humdi.net/vnstat/"

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/vergoh/vnstat"
	inherit git-r3
else
	VERIFY_SIG_OPENPGP_KEY_PATH=${BROOT}/usr/share/openpgp-keys/teemutoivola.asc
	inherit verify-sig

	SRC_URI="https://humdi.net/vnstat/${P}.tar.gz"
	SRC_URI+=" https://github.com/vergoh/vnstat/releases/download/v${PV}/${P}.tar.gz"
	SRC_URI+=" verify-sig? (
			https://humdi.net/vnstat/${P}.tar.gz.asc
			https://github.com/vergoh/vnstat/releases/download/v${PV}/${P}.tar.gz.asc
		)"

	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"

	BDEPEND="verify-sig? ( sec-keys/openpgp-keys-teemutoivola )"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="gd selinux test"
RESTRICT="!test? ( test )"

RDEPEND="
	acct-group/vnstat
	acct-user/vnstat
	dev-db/sqlite
	gd? ( media-libs/gd[png] )
"
DEPEND="
	${RDEPEND}
	test? ( dev-libs/check )
"
RDEPEND+=" selinux? ( sec-policy/selinux-vnstatd )"

PATCHES=(
	"${FILESDIR}"/${PN}-2.9-conf.patch
)

src_compile() {
	emake \
		${PN} \
		${PN}d \
		$(usex gd ${PN}i '')
}

src_install() {
	use gd && dobin vnstati
	dobin vnstat vnstatd

	exeinto /usr/share/${PN}
	newexe "${FILESDIR}"/vnstat.cron-r1 vnstat.cron

	insinto /etc
	doins cfg/vnstat.conf
	fowners root:vnstat /etc/vnstat.conf

	keepdir /var/lib/vnstat
	fowners vnstat:vnstat /var/lib/vnstat

	newconfd "${FILESDIR}"/vnstatd.confd-r1 vnstatd
	newinitd "${FILESDIR}"/vnstatd.initd-r2 vnstatd

	systemd_newunit "${FILESDIR}"/vnstatd.systemd vnstatd.service
	newtmpfiles "${FILESDIR}"/vnstatd.tmpfile vnstatd.conf

	use gd && doman man/vnstati.1

	doman man/vnstat.1 man/vnstatd.8

	newdoc INSTALL README.setup
	dodoc CHANGES README UPGRADE FAQ examples/vnstat.cgi
}

pkg_postinst() {
	tmpfiles_process vnstatd.conf
}
