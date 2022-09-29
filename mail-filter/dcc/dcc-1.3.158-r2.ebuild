# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Distributed Checksum Clearinghouse"
HOMEPAGE="https://www.rhyolite.com/dcc/"
SRC_URI="https://www.rhyolite.com/dcc/source/old/${P}.tar.Z"

LICENSE="DCC GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ppc ppc64 sparc x86"
IUSE="cgi ipv6 rrdtool milter"

RDEPEND="
	dev-lang/perl
	|| (
		net-ftp/ftp
		net-misc/curl
		net-misc/wget
		www-client/fetch
	)
	milter? ( mail-filter/libmilter:= )
	rrdtool? ( net-analyzer/rrdtool )"
DEPEND="${RDEPEND}"

dcc_cgibin=var/www/localhost/cgi-bin/dcc
dcc_homedir=var/dcc
dcc_libexec=usr/sbin
dcc_man=usr/share/man
dcc_rundir=var/run/dcc

PATCHES=(
	"${FILESDIR}"/${PN}-1.3.140-freebsd.patch
	"${FILESDIR}"/${P}-fno-common.patch
	"${FILESDIR}"/${P}-clang16.patch
)

src_configure() {
	tc-export CC AR RANLIB
	local myconf=(
		--bindir="${EPREFIX}"/usr/bin
		--homedir="${EPREFIX}"/${dcc_homedir}
		--libexecdir="${EPREFIX}"/${dcc_libexec}
		--mandir="${EPREFIX}"/usr/share/man
		--enable-dccifd
		--enable-server
		--with-DDC-MD5
		--with-installroot="${D}"
		--with-rundir="${EPREFIX}"/${dcc_rundir}
		--with-uid=root
		--with-updatedcc_pfile="${EPREFIX}"/${dcc_homedir}/updatecc.pfile
		--with-db-memory=64
		--with-max-db-mem=128
		--with-max-log-size=0
		--with-make-cmd=${MAKE:-make}
		$(use_enable ipv6 IPv6)
		$(use_enable milter dccm)
		$(use_with cgi cgibin ${dcc_cgibin})
		$(use_with milter sendmail)
	)

	einfo "Using config: ${myconf[@]}"

	# This is NOT a normal configure script.
	./configure "${myconf[@]}" || die "configure failed!"
}

moveconf() {
	local i
	for i in $@; do
		mv "${ED}/${dcc_homedir}/${i}" "${ED}"/etc/dcc || die
		dosym ../../etc/dcc/"${i}" "${dcc_homedir}/${i}"
	done
}

src_install() {
	# stolen from the RPM .spec and modified for gentoo
	export MANOWN=root
	export MANGRP=$(id -g -n root)
	export BINOWN="${MANOWN}"
	export BINGRP="${MANGRP}"
	export DCC_PROTO_HOMEDIR="${ED}/${dcc_homedir}"
	export DCC_CGIBINDIR="${ED}/${dcc_cgibin}"
	export DCC_SUID="${BINOWN}"
	export DCC_OWN="${BINOWN}"
	export DCC_GRP="${BINGRP}"

	dodir /etc/cron.daily "${dcc_homedir}" /usr/bin /usr/sbin /usr/share/man/man{0,8} /etc/dcc
	if use cgi ; then
		dodir "${dcc_cgibin}"
	fi
	keepdir /var/log/dcc

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
		-i "${ED}/${dcc_homedir}/dcc_conf" || die

	if use milter ; then
		# enable milter
		sed -i -e "s:^[\t #]*\(DCCM_ENABLE[\t ]*=[\t ]*\).*:\1on:g" \
			"${ED}/${dcc_homedir}"/dcc_conf || die
	fi

	# provide cronjob
	mv "${ED}"/usr/sbin/cron-dccd "${ED}"/etc/cron.daily/dccd || die "mv failed"

	# clean up
	mv "${ED}"/usr/sbin/logger "${ED}"/usr/sbin/logger-dcc || die "mv failed"

	if ! use rrdtool; then
		# remove rrdtool interface scripts
		rm "${ED}"/usr/sbin/dcc-stats-{collect,graph,init} || die "Failed to clean up rrdtool scripts"
	fi

	# clean up
	rm "${ED}"/usr/sbin/{rcDCC,updatedcc} || die

	# place configuration files into /etc instead of /var/dcc
	moveconf dcc_conf flod grey_flod grey_whitelist ids map map.txt whiteclnt whitecommon whitelist

	newinitd "${FILESDIR}"/dcc.initd-1.3.154 dcc
	newconfd "${FILESDIR}"/dcc.confd dcc

	rmdir "${ED}"/var/dcc/log/ || die

	dodoc CHANGES RESTRICTIONS
	doman *.{0,8}
}
