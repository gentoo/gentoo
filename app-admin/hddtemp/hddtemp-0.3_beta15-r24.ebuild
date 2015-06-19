# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/hddtemp/hddtemp-0.3_beta15-r24.ebuild,v 1.4 2014/11/01 20:12:03 aidecoe Exp $

EAPI=4

inherit eutils autotools systemd

MY_P=${P/_beta/-beta}
DBV=20080531

DESCRIPTION="A simple utility to read the temperature of SMART capable hard drives"
HOMEPAGE="http://savannah.nongnu.org/projects/hddtemp/"
SRC_URI="http://download.savannah.gnu.org/releases/hddtemp/${MY_P}.tar.bz2 mirror://gentoo/hddtemp-${DBV}.db.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~sparc ~x86"
IUSE="network-cron nls selinux"

DEPEND=""
RDEPEND="selinux? ( sec-policy/selinux-hddtemp )"

S="${WORKDIR}/${MY_P}"

DOCS=(README TODO ChangeLog)

src_prepare() {
	epatch "${FILESDIR}"/${P}-satacmds.patch
	epatch "${FILESDIR}"/${P}-byteswap.patch
	epatch "${FILESDIR}"/${P}-execinfo.patch
	epatch "${FILESDIR}"/${P}-nls.patch
	epatch "${FILESDIR}"/${P}-iconv.patch
	epatch "${FILESDIR}"/${P}-dontwake.patch
	AT_M4DIR="m4" eautoreconf
}

src_configure() {
	local myconf

	myconf="--with-db-path=/usr/share/hddtemp/hddtemp.db"
	# disabling nls breaks compiling
	use nls || myconf="--disable-nls ${myconf}"
	econf ${myconf}
}

src_install() {
	default

	insinto /usr/share/hddtemp
	newins "${WORKDIR}/hddtemp-${DBV}.db" hddtemp.db
	doins "${FILESDIR}"/hddgentoo.db

	update_db "${D}/usr/share/hddtemp/hddgentoo.db" "${D}/usr/share/hddtemp/hddtemp.db"
	newconfd "${FILESDIR}"/hddtemp-conf.d hddtemp
	newinitd "${FILESDIR}"/hddtemp-init hddtemp
	systemd_newunit "${FILESDIR}"/hddtemp.service-r1 "${PN}.service"
	systemd_install_serviced "${FILESDIR}"/hddtemp.service.conf

	dosbin "${FILESDIR}"/update-hddtemp.db

	if use network-cron ; then
		exeinto /etc/cron.monthly
		echo -e "#!/bin/sh\n/usr/sbin/update-hddtemp.db" > "${T}"/hddtemp.cron
		newexe "${T}"/hddtemp.cron update-hddtemp.db
	fi
}

pkg_postinst() {
	elog "In order to update your hddtemp database, run:"
	elog "  update-hddtemp.db"
	elog ""
	elog "If your hard drive is not recognized by hddtemp, please consider"
	elog "submitting your HDD info for inclusion into the Gentoo hddtemp"
	elog "database by filing a bug at https://bugs.gentoo.org/"
	echo
	ewarn "If hddtemp complains but finds your HDD temperature sensor, use the"
	ewarn "--quiet option to suppress the warning."
}

update_db() {
	local src=$1
	local dst=$2

	while read line ; do
		if [[ -z $(echo "${line}" | sed -re 's/(^#.*|^\w*$)//') ]]; then
			echo "${line}" >> "${dst}"
		fi

		id=$(echo "${line}" | grep -o '"[^"]*"')

		grep "${id}" "${dst}" 2>&1 >/dev/null || echo "${line}" >> "${dst}"
	done < "${src}"
}
