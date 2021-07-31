# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

VERIFY_SIG_OPENPGP_KEY_PATH=${BROOT}/usr/share/openpgp-keys/teemutoivola.asc
inherit flag-o-matic toolchain-funcs verify-sig

DESCRIPTION="Console-based network traffic monitor that keeps statistics of network usage"
HOMEPAGE="https://humdi.net/vnstat/"
SRC_URI="https://humdi.net/vnstat/${P}.tar.gz"
SRC_URI+=" verify-sig? ( https://humdi.net/vnstat/${P}.tar.gz.asc )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm ~hppa ppc ppc64 sparc x86"
IUSE="gd selinux test"
RESTRICT="!test? ( test )"

RDEPEND="gd? ( media-libs/gd[png] )"
DEPEND="
	${RDEPEND}
	test? ( dev-libs/check )
"
RDEPEND+=" acct-group/vnstat
	acct-user/vnstat
	selinux? ( sec-policy/selinux-vnstatd )"
BDEPEND="verify-sig? ( app-crypt/openpgp-keys-teemutoivola )"

src_prepare() {
	default

	tc-export CC

	sed -i \
		-e 's|vnstat[.]log|vnstatd.log|' \
		-e 's|vnstat[.]pid|vnstatd/vnstatd.pid|' \
		-e 's|/var/run|/run|' \
		cfg/${PN}.conf || die

	sed -i \
		-e '/PIDFILE/s|/var/run|/run|' \
		src/common.h || die
}

src_configure() {
	tc-export CC

	# Fails to build with GCC 10
	append-flags -fcommon

	default
}

src_compile() {
	emake ${PN} ${PN}d $(usex gd ${PN}i '')
}

src_install() {
	use gd && dobin vnstati
	dobin vnstat vnstatd

	exeinto /etc/cron.hourly
	newexe "${FILESDIR}"/vnstat.cron vnstat

	insinto /etc
	doins cfg/vnstat.conf
	fowners root:vnstat /etc/vnstat.conf

	newconfd "${FILESDIR}"/vnstatd.confd vnstatd
	newinitd "${FILESDIR}"/vnstatd.initd-r1 vnstatd

	use gd && doman man/vnstati.1
	doman man/vnstat.1 man/vnstatd.1

	newdoc INSTALL README.setup
	dodoc CHANGES README UPGRADE FAQ examples/vnstat.cgi
}
