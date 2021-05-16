# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools toolchain-funcs

DESCRIPTION="Fast output system for Snort"
HOMEPAGE="https://sourceforge.net/projects/barnyard"
SRC_URI="
	mirror://sourceforge/barnyard/barnyard-${PV/_/-}.tar.gz
	https://dev.gentoo.org/~jer/${P}-patches.tar.xz
"

SLOT="0"
LICENSE="QPL-1.0 GPL-2"     # GPL-2 for init script
KEYWORDS="~amd64 -sparc ~x86"
IUSE="mysql postgres sguil"

DEPEND="
	net-libs/libpcap
	mysql? ( dev-db/mysql-connector-c:0= )
	postgres? ( dev-db/postgresql:*[server] )
	sguil? ( dev-lang/tcl:0 )
"
RDEPEND="
	${DEPEND}
	net-analyzer/snort
"

S=${WORKDIR}/${P/_/-}

DOCS="AUTHORS README docs/*"
PATCHES=(
	"${WORKDIR}"/${P}-64bit.patch
	"${WORKDIR}"/${P}-canonical-ar.patch
	"${WORKDIR}"/${P}-configure-in.patch
)
SGUIL_PATCHES=(
	"${WORKDIR}"/${P}-op_plugbase.c.patch
	"${WORKDIR}"/${P}-sguil_files.patch
)

src_prepare() {
	use sguil && PATCHES+=( "${SGUIL_PATCHES[@]}" )
	default

	eautoreconf
}

src_configure() {
	tc-export AR

	econf \
		$(use_enable mysql) \
		$(use_enable postgres) \
		$(use_enable sguil tcl) \
		--sysconfdir=/etc/snort
}

src_install() {
	default

	keepdir /var/log/snort
	keepdir /var/log/snort/archive

	insinto /etc/snort
	newins etc/barnyard.conf barnyard.conf
	newconfd "${FILESDIR}"/barnyard.confd barnyard
	newinitd "${FILESDIR}"/barnyard.rc6 barnyard

	if use sguil ; then
		sed -i -e "/config hostname:/s%snorthost%$(hostname)%" \
		-e "/config interface/s:fxp0:eth0:" \
		-e "s:output alert_fast:#output alert_fast:" \
		-e "s:output log_dump:#output log_dump:" \
			"${D}/etc/snort/barnyard.conf" || die "sed failed"

		sed -i -e s:/var/log/snort:/var/lib/sguil/$(hostname): \
		-e s:/var/run/barnyard.pid:/var/run/sguil/barnyard.pid: \
			"${D}/etc/conf.d/barnyard" || die "sed failed"

		sed -i -e "/start-stop-daemon --start/s:--exec:-c sguil --exec:" \
			"${D}/etc/init.d/barnyard" || die "sed failed"
	fi
}

pkg_postinst() {
	if use sguil ; then
		elog
		elog "Make sure to edit /etc/snort/barnyard.conf and uncomment the"
		elog "sguil section along with supplying the appropriate database"
		elog "information."
		elog
	fi
}
