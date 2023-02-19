# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd toolchain-funcs

GENTOO_PATCH="${P}-gentoo.patch"

DESCRIPTION="Tool to locally check for signs of a rootkit"
HOMEPAGE="http://www.chkrootkit.org/"
SRC_URI="ftp://chkrootkit.org/pub/seg/pac/${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~tupone/distfiles/${CATEGORY}/${PN}/${GENTOO_PATCH}.bz2"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"
IUSE="+cron"

RDEPEND="cron? ( virtual/cron )"

PATCHES=(
	"${WORKDIR}/${P}-gentoo.patch"
	"${FILESDIR}/${PN}-0.55-fcntl_h.patch"
	"${FILESDIR}/${PN}-0.55-limits_h.patch"
)

src_prepare() {
	default

	sed -e 's:/var/adm/:/var/log/:g' \
		-i chklastlog.c || die
}

src_compile() {
	emake CC="$(tc-getCC)" STRIP=/bin/true sense
}

src_install() {
	dosbin chkdirs chklastlog chkproc chkrootkit chkwtmp chkutmp ifpromisc strings-static
	dodoc ACKNOWLEDGMENTS README*

	if use cron ; then
		exeinto /etc/cron.weekly
		newexe "${FILESDIR}"/${PN}.cron ${PN}
	fi

	systemd_dounit "${FILESDIR}/${PN}.timer" "${FILESDIR}/${PN}.service"
}

pkg_postinst() {
	if use cron ; then
		elog
		elog "Edit ${EROOT}/etc/cron.weekly/chkrootkit to activate chkrootkit!"
		elog
	fi

	if systemd_is_booted || has_version sys-apps/systemd ; then
		elog
		elog "To enable the systemd timer, run the following command:"
		elog "   systemctl enable --now chkrootkit.timer"
		elog
	fi

	elog
	elog "Some applications, such as portsentry, will cause chkrootkit"
	elog "to produce false positives.  Read the chkrootkit FAQ at"
	elog "http://www.chkrootkit.org/ for more information."
	elog
}
