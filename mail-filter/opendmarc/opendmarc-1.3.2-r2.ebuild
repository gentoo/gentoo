# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit user multilib systemd

DESCRIPTION="Open source DMARC implementation "
HOMEPAGE="http://www.trusteddomain.org/opendmarc/"
SRC_URI="mirror://sourceforge/opendmarc/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sparc x86"
IUSE="spf +reports static-libs"

DEPEND="reports? ( dev-perl/DBI )
	|| ( mail-filter/libmilter mail-mta/sendmail )"
RDEPEND="${DEPEND}
	reports? (
		dev-perl/DBD-mysql
		dev-perl/HTTP-Message
		dev-perl/Switch
	)
	spf? ( mail-filter/libspf2 )"

pkg_setup() {
	enewgroup milter
	enewuser milter -1 -1 /var/lib/milter milter
}

src_prepare() {
	default
	if use !reports ; then
		sed -i -e '/^SUBDIRS =/s/reports//' Makefile.in || die
	fi
}

src_configure() {
	econf \
		--docdir="${EPREFIX}"/usr/share/doc/${PF} \
		--htmldir="${EPREFIX}"/usr/share/doc/${PF}/html \
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
		-e 's:^# UserID .*$:UserID milter:' \
		-e "s:^# PidFile .*:PidFile ${EPREFIX}/var/run/opendmarc/opendmarc.pid:" \
		-e '/^# Socket /s:^# ::' \
		"${S}"/opendmarc/opendmarc.conf.sample \
		> "${ED}"/etc/opendmarc/opendmarc.conf \
		|| die
}
