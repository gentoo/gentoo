# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit eapi9-ver systemd

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
	dev-db/sqlite:3
	gd? ( media-libs/gd:2=[png] )
"
DEPEND="
	${RDEPEND}
	test? ( dev-libs/check )
"
RDEPEND+=" selinux? ( sec-policy/selinux-vnstatd )"

PATCHES=(
	"${FILESDIR}"/${PN}-2.13-unit_as_user.patch
)

src_configure() {
	local myeconfargs=(
		# do not pass /usr/local
		--disable-extra-paths
		$(use_enable gd image-output)
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	# `vnstat --showconfig` generates the configfile if not crosscompiling
	# use the same file in anycase
	insinto /etc/
	doins cfg/vnstat.conf

	keepdir /var/lib/${PN}
	fowners -R vnstat:vnstat /var/lib/${PN}

	newconfd "${FILESDIR}"/vnstatd.confd-r2 vnstatd
	newinitd "${FILESDIR}"/vnstatd.initd-r4 vnstatd

	systemd_newunit examples/systemd/simple/vnstat.service vnstatd.service

	dodoc examples/*.{cgi,php}
}

pkg_postinst() {
	if ver_replacing -lt 2.13-r3; then
		ewarn "The daemon is now started directly as an unprivileged user."
		ewarn "Update VNSTATD_USER in ${EROOT}/etc/conf.d/vnstatd to override the default user 'vnstat'."
		ewarn "Please adjust permissions on ${EROOT}/var/lib/vnstat to be owned by vnstat:vnstat"
		ewarn "e.g. chown -R vnstat:vnstat ${EROOT}/var/lib/vnstat"
	fi
}
