# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit systemd

MY_P="${P/_p/p}"

DESCRIPTION="Lightweight NTP server ported from OpenBSD"
HOMEPAGE="http://www.openntpd.org/"
SRC_URI="mirror://openbsd/OpenNTPD/${MY_P}.tar.gz"

LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="~amd64 arm ~arm64 ~hppa ~ia64 ~mips ppc ppc64 ~s390 sparc ~x86"
IUSE="constraints libressl selinux"

DEPEND="
	!net-misc/ntp[-openntpd]
	constraints? (
		libressl? ( dev-libs/libressl:= )
		!libressl? ( dev-libs/libretls:= )
	)"

RDEPEND="
	${DEPEND}
	acct-group/openntpd
	acct-user/openntpd
	selinux? ( sec-policy/selinux-ntp )"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default

	# fix /run path
	sed -i 's:/var/run/ntpd:/run/ntpd:g' src/ntpctl.8 src/ntpd.8 || die
	sed -i 's:LOCALSTATEDIR "/run/ntpd:"/run/ntpd:' src/ntpd.h || die

	# fix ntpd.drift path
	sed -i 's:/var/db/ntpd.drift:/var/lib/openntpd/ntpd.drift:g' src/ntpd.8 || die
	sed -i 's:"/db/ntpd.drift":"/openntpd/ntpd.drift":' src/ntpd.h || die

	# fix default config to use gentoo pool
	sed -i 's:^server:#server:g' ntpd.conf || die
	printf "\n# Choose servers announced from Gentoo NTP Pool\nservers 0.gentoo.pool.ntp.org\nservers 1.gentoo.pool.ntp.org\nservers 2.gentoo.pool.ntp.org\nservers 3.gentoo.pool.ntp.org\n" >> ntpd.conf || die

	use constraints || sed -ie 's/^constraints/#constraints/g' ntpd.conf || die
}

src_configure() {
	econf \
		--with-privsep-user=openntpd \
		$(use_enable constraints https-constraint)
}

src_install() {
	default

	rm -r "${ED}"/var || die

	newinitd "${FILESDIR}/${PN}.init.d-20080406-r6" ntpd
	newconfd "${FILESDIR}/${PN}.conf.d-20080406-r6" ntpd

	systemd_newunit "${FILESDIR}/${PN}.service-20080406-r4" ntpd.service
}
