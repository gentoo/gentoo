# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit systemd

DESCRIPTION="Rotates, compresses, and mails system logs"
HOMEPAGE="https://github.com/logrotate/logrotate"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/${PV}/${P}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd"
IUSE="acl +cron selinux bzip2"

CDEPEND="
	>=dev-libs/popt-1.5
	selinux? ( sys-libs/libselinux )
	acl? ( virtual/acl )"

DEPEND="${CDEPEND}
	>=sys-apps/sed-4"

RDEPEND="${CDEPEND}
	selinux? ( sec-policy/selinux-logrotate )
	cron? ( virtual/cron )
	bzip2? ( app-arch/bzip2 )"

install_cron_file() {
	exeinto /etc/cron.daily
	newexe "${S}"/examples/logrotate.cron "${PN}"
}

PATCHES=(
	"${FILESDIR}/${P}-ignore-hidden.patch"
	"${FILESDIR}/${P}-fbsd.patch"
)

src_prepare() {
	default
	sed -i -e 's#/usr/sbin/logrotate#/usr/bin/logrotate#' "${S}"/examples/logrotate.{cron,service} || die
}

src_configure() {
	if use bzip2 ; then
		compressconf="--with-compress-command=/bin/bzip2 --with-uncompress-command=/bin/bunzip2 --with-compress-extension=.bz2"
	fi
	econf $(use_with acl) $(use_with selinux) ${compressconf}
}

src_test() {
	emake test
}

src_install() {
	insinto /usr
	dobin logrotate
	doman logrotate.8
	dodoc ChangeLog.md examples/logrotate-default

	insinto /etc
	doins "${FILESDIR}"/logrotate.conf

	use cron && install_cron_file

	systemd_dounit examples/logrotate.{service,timer}

	keepdir /etc/logrotate.d
}

pkg_postinst() {
	elog "The ${PN} binary is now installed under /usr/bin. Please"
	elog "update your links"
	elog
	if [[ -z ${REPLACING_VERSIONS} ]] ; then
		elog "If you wish to have logrotate e-mail you updates, please"
		elog "emerge virtual/mailx and configure logrotate in"
		elog "/etc/logrotate.conf appropriately"
		elog
		elog "Additionally, /etc/logrotate.conf may need to be modified"
		elog "for your particular needs.  See man logrotate for details."
	fi
}
