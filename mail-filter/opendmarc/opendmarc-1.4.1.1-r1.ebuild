# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools multilib systemd

DESCRIPTION="Open source DMARC implementation"
HOMEPAGE="http://www.trusteddomain.org/opendmarc/"
SRC_URI="https://github.com/trusteddomainproject/OpenDMARC/archive/rel-${PN}-${PV//./-}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0/3"  # 1.4 has API breakage with 1.3, yet uses same soname
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="spf +reports static-libs"

DEPEND="reports? ( dev-perl/DBI )
	|| ( mail-filter/libmilter mail-mta/sendmail )"
RDEPEND="${DEPEND}
	acct-user/opendmarc
	reports? (
		dev-perl/DBD-mysql
		dev-perl/HTTP-Message
		dev-perl/Switch
	)
	spf? ( mail-filter/libspf2 )"

S=${WORKDIR}/OpenDMARC-rel-${PN}-${PV//./-}

src_prepare() {
	default

	eautoreconf
	if use !reports ; then
		sed -i -e '/^SUBDIRS =/s/reports//' Makefile.in || die
	fi
}

src_configure() {
	econf \
		$(use_with spf) \
		$(use_with spf spf2-include "${EPREFIX}"/usr/include/spf2) \
		$(use_with spf spf2-lib "${EPREFIX}"/usr/$(get_libdir)) \
		$(use_enable static-libs static)
}

src_install() {
	default

	use static-libs || rm -f "${ED}"/usr/$(get_libdir)/*.la

	newinitd "${FILESDIR}"/opendmarc.initd opendmarc
	newconfd "${FILESDIR}"/opendmarc.confd opendmarc
	systemd_dounit "${FILESDIR}/${PN}.service"

	dodir /etc/opendmarc

	# create config file
	sed \
		-e 's:^# UserID .*$:UserID opendmarc:' \
		-e "s:^# PidFile .*:PidFile ${EPREFIX}/var/run/opendmarc/opendmarc.pid:" \
		-e '/^# Socket /s:^# ::' \
		"${S}"/opendmarc/opendmarc.conf.sample \
		> "${ED}"/etc/opendmarc/opendmarc.conf \
		|| die
}
