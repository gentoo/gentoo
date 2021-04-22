# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit systemd toolchain-funcs

DESCRIPTION="Merging locate is an utility to index and quickly search for files"
HOMEPAGE="https://pagure.io/mlocate"
SRC_URI="http://releases.pagure.org/mlocate/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ppc ppc64 ~s390 sparc ~x86"
IUSE="nls selinux"

BDEPEND="
	acct-group/locate
	nls? ( sys-devel/gettext )
"
RDEPEND="
	acct-group/locate
	!sys-apps/slocate
	!sys-apps/rlocate
	selinux? ( sec-policy/selinux-slocate )
"

src_configure() {
	econf $(use_enable nls)
}

src_compile() {
	emake groupname=locate AR="$(tc-getAR)"
}

src_install() {
	emake groupname=locate DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog README NEWS

	insinto /etc
	doins "${FILESDIR}"/updatedb.conf
	doins "${FILESDIR}"/mlocate-cron.conf
	fperms 0644 /etc/{updatedb,mlocate-cron}.conf

	insinto /etc/cron.daily
	newins "${FILESDIR}"/mlocate.cron-r3 mlocate
	fperms 0755 /etc/cron.daily/mlocate

	keepdir /var/lib/mlocate
	fowners 0:locate /var/lib/mlocate
	fperms 0750 /var/lib/mlocate

	systemd_dounit "${FILESDIR}"/updatedb.{service,timer}
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		elog "The database for the locate command is generated daily by a cron job,"
		elog "if you install for the first time you can run the updatedb command manually now."
		elog
		elog "Note that the /etc/updatedb.conf file is generic,"
		elog "please customize it to your system requirements."
	fi
}
