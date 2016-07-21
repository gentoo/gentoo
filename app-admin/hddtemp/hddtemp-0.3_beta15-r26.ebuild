# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils autotools readme.gentoo-r1 systemd

MY_P=${P/_beta/-beta}
DBV=20080531

DESCRIPTION="A simple utility to read the temperature of SMART capable hard drives"
HOMEPAGE="https://savannah.nongnu.org/projects/hddtemp/"
SRC_URI="http://download.savannah.gnu.org/releases/hddtemp/${MY_P}.tar.bz2 mirror://gentoo/hddtemp-${DBV}.db.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~sparc ~x86"
IUSE="network-cron nls selinux"

DEPEND=""
RDEPEND="selinux? ( sec-policy/selinux-hddtemp )"

S="${WORKDIR}/${MY_P}"

DOCS=(README TODO ChangeLog)

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

PATCHES=(
	"${FILESDIR}"/${P}-satacmds.patch
	"${FILESDIR}"/${P}-byteswap.patch
	"${FILESDIR}"/${P}-execinfo.patch
	"${FILESDIR}"/${P}-nls.patch
	"${FILESDIR}"/${P}-iconv.patch
	"${FILESDIR}"/${P}-dontwake.patch
)

src_prepare() {
	epatch "${PATCHES[@]}"
	mv "${S}"/configure.{in,ac} || die
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

pkg_config() {
	cd "${ROOT}"/usr/share/hddtemp || die

	einfo "Trying to download the latest hddtemp.db file"
	wget http://www.guzu.net/linux/hddtemp.db -O hddtemp.db \
		|| die "failed to download hddtemp.db"

	update_db "hddgentoo.db" "hddtemp.db"
}
