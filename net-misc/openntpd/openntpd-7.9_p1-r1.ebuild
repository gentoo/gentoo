# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools systemd

MY_P="${P/_p/p}"

DESCRIPTION="Lightweight NTP server ported from OpenBSD"
HOMEPAGE="https://www.openntpd.org/"
SRC_URI="mirror://openbsd/OpenNTPD/${MY_P}.tar.gz"

LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~mips ppc ~ppc64 ~riscv ~s390 ~sparc x86"
IUSE="constraints selinux"

DEPEND="
	!net-misc/ntp[-openntpd]
	constraints? ( dev-libs/libretls:= )"

RDEPEND="
	${DEPEND}
	acct-group/openntpd
	acct-user/openntpd
	selinux? ( sec-policy/selinux-ntp )"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default
	eautoreconf

	# fix default config to use gentoo pool
	sed -i 's:^server:#server:g' ntpd.conf || die
	printf "\n# Choose servers announced from Gentoo NTP Pool\nservers 0.gentoo.pool.ntp.org\nservers 1.gentoo.pool.ntp.org\nservers 2.gentoo.pool.ntp.org\nservers 3.gentoo.pool.ntp.org\n" >> ntpd.conf || die

	use constraints || sed -ie 's/^constraint/#constraint/g' ntpd.conf || die
}

src_configure() {
	econf \
		--localstatedir="${EPREFIX}"/var/lib/openntpd \
		--runstatedir="${EPREFIX}"/run \
		--with-privsep-user=openntpd \
		$(use_enable constraints https-constraint) \
		$(use_with constraints cacert "${EPREFIX}"/etc/ssl/certs/ca-certificates.crt)
}

src_install() {
	default

	rm -r "${ED}"/var "${ED}"/run || die

	newinitd "${FILESDIR}/${PN}.init.d-20080406-r6" ntpd
	newconfd "${FILESDIR}/${PN}.conf.d-20080406-r6" ntpd

	systemd_newunit "${FILESDIR}/${PN}.service-20080406-r4" ntpd.service
}
