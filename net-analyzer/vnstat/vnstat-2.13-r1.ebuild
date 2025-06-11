# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd tmpfiles

DESCRIPTION="Console-based network traffic monitor that keeps statistics of network usage"
HOMEPAGE="https://humdi.net/vnstat/"

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/vergoh/vnstat"
	inherit git-r3
else
	VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/teemutoivola.asc
	inherit verify-sig

	SRC_URI="
		https://humdi.net/vnstat/${P}.tar.gz
		https://github.com/vergoh/vnstat/releases/download/v${PV}/${P}.tar.gz
		verify-sig? (
			https://humdi.net/vnstat/${P}.tar.gz.asc
			https://github.com/vergoh/vnstat/releases/download/v${PV}/${P}.tar.gz.asc
		)
	"

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

src_configure() {
	local myeconfargs=(
		$(use_enable gd image-output)
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	exeinto /usr/share/${PN}
	newexe "${FILESDIR}"/vnstat.cron-r1 vnstat.cron

	newconfd "${FILESDIR}"/vnstatd.confd-r1 vnstatd
	newinitd "${FILESDIR}"/vnstatd.initd-r2 vnstatd

	systemd_newunit "${FILESDIR}"/vnstatd.systemd vnstatd.service
	newtmpfiles "${FILESDIR}"/vnstatd.tmpfile vnstatd.conf

	newdoc INSTALL README.setup
	dodoc CHANGES README UPGRADE FAQ examples/vnstat.cgi
}

pkg_postinst() {
	tmpfiles_process vnstatd.conf
}
