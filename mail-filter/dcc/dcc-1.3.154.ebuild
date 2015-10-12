# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit base eutils flag-o-matic toolchain-funcs

DESCRIPTION="Distributed Checksum Clearinghouse"
HOMEPAGE="http://www.rhyolite.com/anti-spam/dcc/"
SRC_URI="http://www.rhyolite.com/anti-spam/dcc/source/old/${P}.tar.Z"

LICENSE="DCC GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd" # ~amd64-fbsd
IUSE="cgi ipv6 rrdtool milter"

RDEPEND="dev-lang/perl
	rrdtool? ( net-analyzer/rrdtool )
	|| ( net-misc/wget www-client/fetch net-misc/curl net-ftp/ftp )
	milter? ( || ( mail-filter/libmilter mail-mta/sendmail ) )"
DEPEND="sys-apps/sed
	sys-devel/gcc
	${RDEPEND}"

dcc_cgibin=/var/www/localhost/cgi-bin/dcc
dcc_homedir=/var/dcc
dcc_libexec=/usr/sbin
dcc_man=/usr/share/man
dcc_rundir=/var/run/dcc

PATCHES=( "${FILESDIR}"/dcc-1.3.140-freebsd.patch )

src_configure() {
	tc-export CC AR RANLIB
	local myconf
	myconf="${myconf} --homedir=${dcc_homedir}"
	myconf="${myconf} --bindir=/usr/bin"
	myconf="${myconf} --libexecdir=${dcc_libexec}"
	myconf="${myconf} --mandir=/usr/share/man"
	myconf="${myconf} --with-updatedcc_pfile=${dcc_homedir}/updatecc.pfile"
	myconf="${myconf} --with-installroot=${D}"
	# sigh.  should be DCC-MD5 but see line 486 in the shipped configure script
	myconf="${myconf} --with-DDC-MD5"
	myconf="${myconf} --with-uid=root"
	myconf="${myconf} --enable-server"
	myconf="${myconf} --enable-dccifd"
	myconf="${myconf} --with-rundir=${dcc_rundir}"
	myconf="${myconf} --with-db-memory=64"
	myconf="${myconf} --with-max-db-mem=128"
	myconf="${myconf} --with-max-log-size=0"
	myconf="${myconf} --with-make-cmd=${MAKE:-make}"
	myconf="${myconf} $(use_enable ipv6 IPv6)"
	myconf="${myconf} $(use_with cgi cgibin ${dcc_cgibin})"
	myconf="${myconf} $(use_enable milter dccm)"
	use milter && myconf="${myconf} --with-sendmail="

	einfo "Using config: ${myconf}"

	# This is NOT a normal configure script.
	./configure ${myconf} || die "configure failed!"
}

moveconf() {
	local into=/etc/dcc/
	for i in $@; do
		mv "${D}${dcc_homedir}/${i}" "${D}${into}"
		dosym "${into}${i}" "${dcc_homedir}/${i}"
	done
}

src_install() {
	# stolen from the RPM .spec and modified for gentoo
	MANOWN=root MANGRP=$(id -g -n root) export MANOWN MANGRP
	BINOWN="${MANOWN}" BINGRP="${MANGRP}" export BINOWN BINGRP
	DCC_PROTO_HOMEDIR="${D}${dcc_homedir}" export DCC_PROTO_HOMEDIR
	DCC_CGIBINDIR="${D}${dcc_cgibin}" export DCC_CGIBINDIR
	DCC_SUID="${BINOWN}" DCC_OWN="${BINOWN}" DCC_GRP="${BINGRP}" export DCC_SUID DCC_OWN DCC_GRP

	dodir /etc/cron.daily "${dcc_homedir}" /usr/bin /usr/sbin /usr/share/man/man{0,8} /etc/dcc
	if use cgi ; then
		dodir "${dcc_cgibin}"
	fi
	keepdir /var/log/dcc

	# This package now takes "${D}" at compile-time!
	# make DESTDIR="${D}" DCC_BINDIR="${D}"/usr/bin MANDIR="${D}"/usr/share/man/man DCC_HOMEDIR="${D}"${dcc_homedir} install || die
	emake install

	# branding and setting reasonable defaults
	sed -e "s/BRAND=\$/BRAND='Gentoo ${PF}'/;" \
		-e "s/GREY_ENABLE=\$/GREY_ENABLE=off/;" \
		-e "s/DCCM_LOG_AT=5\$/DCCM_LOG_AT=50/;" \
		-e "s,DCCM_LOGDIR=\"log\"\$,DCCM_LOGDIR=\"/var/log/dcc\",;" \
		-e "s/DCCM_ARGS=\$/DCCM_ARGS='-SHELO -Smail_host -SSender -SList-ID'/;" \
		-e "s/DCCIFD_ARGS=\$/DCCIFD_ARGS=\"\$DCCM_ARGS\"/;" \
		-e 's/DCCIFD_ENABLE=off/DCCIFD_ENABLE=on/' \
		-e 's/DBCLEAN_LOGDAYS=14/DBCLEAN_LOGDAYS=1/' \
		-i "${D}${dcc_homedir}/dcc_conf"

	if use milter ; then
		# enable milter
		sed -i -e "s:^[\t #]*\(DCCM_ENABLE[\t ]*=[\t ]*\).*:\1on:g" \
			"${D}${dcc_homedir}"/dcc_conf
	fi

	# provide cronjob
	mv "${D}"/usr/sbin/cron-dccd "${D}"/etc/cron.daily/dccd || die "mv failed"

	# clean up
	mv "${D}"/usr/sbin/logger "${D}"/usr/sbin/logger-dcc || die "mv failed"

	statslist="${D}/usr/sbin/{dcc-stats-graph,dcc-stats-init,dcc-stats-collect}"
	if ! use rrdtool; then
		# remove rrdtool interface scripts
		eval rm -f ${statslist} || die "Failed to clean up rrdtool scripts"
	fi

	# clean up
	rm -f "${D}"/usr/sbin/{rcDCC,updatedcc}

	# place configuration files into /etc instead of /var/dcc
	moveconf dcc_conf flod grey_flod grey_whitelist ids map map.txt whiteclnt whitecommon whitelist

	newinitd "${FILESDIR}"/dcc.initd-1.3.154 dcc
	newconfd "${FILESDIR}"/dcc.confd dcc

	rmdir "${D}"/var/dcc/log/

	dodoc CHANGES RESTRICTIONS
	dohtml *.html
	doman *.{0,8}
}
