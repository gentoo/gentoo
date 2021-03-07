# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3 systemd user tmpfiles

DESCRIPTION="Console-based network traffic monitor that keeps statistics of network usage"
HOMEPAGE="https://humdi.net/vnstat/"
EGIT_REPO_URI="https://github.com/vergoh/vnstat"

LICENSE="GPL-2"
SLOT="0"
IUSE="gd selinux test"
RESTRICT="!test? ( test )"

COMMON_DEPEND="
	dev-db/sqlite
	gd? ( media-libs/gd[png] )
"
DEPEND="
	${COMMON_DEPEND}
	test? ( dev-libs/check )
"
RDEPEND="
	${COMMON_DEPEND}
	selinux? ( sec-policy/selinux-vnstatd )
"

PATCHES=(
	"${FILESDIR}"/${PN}-2.2-conf.patch
	"${FILESDIR}"/${PN}-2.2-drop-root.patch
	"${FILESDIR}"/${PN}-2.2-run.patch
)

pkg_setup() {
	enewgroup vnstat
	enewuser vnstat -1 -1 /var/lib/vnstat vnstat
}

src_compile() {
	emake ${PN} ${PN}d $(usex gd ${PN}i '')
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
	doman man/vnstat.1 man/vnstatd.1

	newdoc INSTALL.md README.setup
	dodoc CHANGES README.md UPGRADE.md FAQ examples/vnstat.cgi
}
