# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools systemd

DESCRIPTION="Open source DMARC implementation"
HOMEPAGE="http://www.trusteddomain.org/opendmarc/"
SRC_URI="https://github.com/trusteddomainproject/OpenDMARC/archive/rel-${PN}-${PV//./-}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/OpenDMARC-rel-${PN}-${PV//./-}"

LICENSE="BSD"
SLOT="0/3"  # 1.4 has API breakage with 1.3, yet uses same soname
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ppc64 ~sparc ~x86"
IUSE="spf +reports"

DEPEND="mail-filter/libmilter:=
	reports? ( dev-perl/DBI )"
RDEPEND="${DEPEND}
	acct-user/opendmarc
	reports? (
		dev-perl/DBD-mysql
		dev-perl/HTTP-Message
		dev-perl/Switch
	)
	spf? ( mail-filter/libspf2 )"

PATCHES=(
	"${FILESDIR}"/${PN}-1.4.1.1-CVE-2021-34555.patch
	"${FILESDIR}"/${PN}-1.4.1.1-underlinking.patch
	"${FILESDIR}"/${PN}-1.4.1.1-arc-seal-crash.patch
)

QA_CONFIG_IMPL_DECL_SKIP=(
	# musl has no re-entrant variants of these, which configure checks for
	res_ninit
	res_ndestroy
)

src_prepare() {
	default

	eautoreconf
	if use !reports ; then
		sed -i -e '/^SUBDIRS =/s/reports//' Makefile.in || die
	fi
}

src_configure() {
	econf \
		--disable-static \
		$(use_with spf) \
		$(use_with spf spf2-include "${EPREFIX}"/usr/include/spf2) \
		$(use_with spf spf2-lib "${EPREFIX}"/usr/$(get_libdir))
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die

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
