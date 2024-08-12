# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DBV="20080531"

inherit autotools readme.gentoo-r1 systemd

DESCRIPTION="A simple utility to read the temperature of SMART capable hard drives"
HOMEPAGE="https://github.com/vitlav/hddtemp"
SRC_URI="
	https://github.com/vitlav/hddtemp/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	mirror://gentoo/hddtemp-${DBV}.db.bz2
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="network-cron nls selinux"

RDEPEND="selinux? ( sec-policy/selinux-hddtemp )"

DISABLE_AUTOFORMATTING="yes"
DOC_CONTENTS="In order to update your hddtemp database, run:
emerge --config =${CATEGORY}/${PF} or update-hddtemp.db (if USE
network-cron is enabled)

If your hard drive is not recognized by hddtemp, please consider
submitting your HDD info for inclusion into the Gentoo hddtemp
database by filing a bug at https://bugs.gentoo.org/

If hddtemp complains but finds your HDD temperature sensor, use the
--quiet option to suppress the warning.
"

PATCHES=( "${FILESDIR}/${P}-nls.patch" )
src_prepare() {
	default
	eautoreconf
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

	update_db "${ED}/usr/share/hddtemp/hddgentoo.db" "${ED}/usr/share/hddtemp/hddtemp.db"
	newconfd "${FILESDIR}"/hddtemp-conf.d hddtemp
	newinitd "${FILESDIR}"/hddtemp-init-r1 hddtemp
	systemd_newunit "${FILESDIR}"/hddtemp.service-r1 "${PN}.service"
	systemd_install_serviced "${FILESDIR}"/hddtemp.service.conf

	readme.gentoo_create_doc

	if use network-cron; then
		dosbin "${FILESDIR}"/update-hddtemp.db
		exeinto /etc/cron.monthly
		echo -e "#!/bin/sh\n/usr/sbin/update-hddtemp.db" > "${T}"/hddtemp.cron
		newexe "${T}"/hddtemp.cron update-hddtemp.db
	fi
}

pkg_postinst() {
	readme.gentoo_print_elog
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
