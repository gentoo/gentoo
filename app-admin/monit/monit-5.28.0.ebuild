# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit bash-completion-r1 pam systemd

DESCRIPTION="Monitoring and managing daemons or similar programs running on a Unix system"
HOMEPAGE="http://mmonit.com/monit/"
SRC_URI="http://mmonit.com/monit/dist/${P}.tar.gz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-linux"
IUSE="ipv6 pam ssl"

RDEPEND="
	ssl? ( dev-libs/openssl:0= )
	"
DEPEND="${RDEPEND}
	pam? ( sys-libs/pam )"
BDEPEND="
	sys-devel/flex
	sys-devel/bison
"

src_prepare() {
	default
	sed -i -e '/^INSTALL_PROG/s/-s//' Makefile.in || die
}

src_configure() {
	local myeconfargs=(
		$(use_with ipv6)
		$(use_with pam)
		$(use_with ssl)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default

	insinto /etc; insopts -m600; doins monitrc
	newinitd "${FILESDIR}"/monit.initd-5.0-r1 monit
	systemd_dounit "${FILESDIR}"/${PN}.service

	use pam && newpamd "${FILESDIR}"/${PN}.pamd ${PN}

	dobashcomp system/bash/monit
}

pkg_postinst() {
	elog "Sample configurations are available at:"
	elog "http://mmonit.com/monit/documentation/"
}
