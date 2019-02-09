# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Fast output system for Snort"
HOMEPAGE="https://sourceforge.net/projects/barnyard"
SRC_URI="
	mirror://sourceforge/barnyard/barnyard-${PV/_/-}.tar.gz
	mirror://gentoo/${P}-patches.tar.bz2"

SLOT="0"
LICENSE="QPL GPL-2"
KEYWORDS="~amd64 -sparc ~x86"
IUSE="mysql postgres sguil"

DEPEND="
	net-libs/libpcap
	mysql? ( dev-db/mysql-connector-c:0= )
	postgres? ( dev-db/postgresql:*[server] )
	sguil? ( dev-lang/tcl:0 )"
RDEPEND="${DEPEND}
	net-analyzer/snort"

S="${WORKDIR}/${P/_/-}"

DOCS="AUTHORS README docs/*"

src_prepare() {
	default
	eapply "${FILESDIR}/barnyard.64bit.diff"
	if use sguil ; then
		eapply "${WORKDIR}/${PV}-sguil_files.patch"
		eapply "${WORKDIR}/${PV}-configure-in.patch"
		cd "${S}/src/output-plugins" || die
		eapply "${WORKDIR}/${PV}-op_plugbase.c.patch"
		cd "${S}" || die
	fi
	eautoreconf
}

src_configure() {
	local myconf
	if use sguil ; then
		myconf="--enable-tcl"
	fi

	econf \
		${myconf} \
		--sysconfdir=/etc/snort \
		$(use_enable postgres) \
		$(use_enable mysql)
}

src_install () {
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
