# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic prefix systemd

DESCRIPTION="File transfer program to keep remote files into sync"
HOMEPAGE="https://rsync.samba.org/"
SRC_URI="https://rsync.samba.org/ftp/rsync/src/${P}.tar.gz"
[[ "${PV}" = *_pre* ]] && SRC_URI="https://rsync.samba.org/ftp/rsync/src-previews/${P/_/}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
[[ ${PV} = *_pre* ]] || \
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~x64-cygwin ~amd64-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="acl examples iconv ipv6 static stunnel xattr"

LIB_DEPEND="acl? ( virtual/acl[static-libs(+)] )
	xattr? ( kernel_linux? ( sys-apps/attr[static-libs(+)] ) )
	>=dev-libs/popt-1.5[static-libs(+)]"
RDEPEND="!static? ( ${LIB_DEPEND//\[static-libs(+)]} )
	iconv? ( virtual/libiconv )"
DEPEND="${RDEPEND}
	static? ( ${LIB_DEPEND} )"

S="${WORKDIR}/${P/_/}"

src_configure() {
	use static && append-ldflags -static
	local myeconfargs=(
		--with-rsyncd-conf="${EPREFIX}"/etc/rsyncd.conf
		--without-included-popt
		$(use_enable acl acl-support)
		$(use_enable iconv)
		$(use_enable ipv6)
		$(use_enable xattr xattr-support)
	)
	econf "${myeconfargs[@]}"
	touch proto.h-tstamp #421625
}

src_install() {
	emake DESTDIR="${D}" install

	newconfd "${FILESDIR}"/rsyncd.conf.d rsyncd
	newinitd "${FILESDIR}"/rsyncd.init.d-r1 rsyncd

	dodoc NEWS OLDNEWS README TODO tech_report.tex

	insinto /etc
	newins "${FILESDIR}"/rsyncd.conf-3.0.9-r1 rsyncd.conf

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/rsyncd.logrotate rsyncd

	insinto /etc/xinetd.d
	newins "${FILESDIR}"/rsyncd.xinetd-3.0.9-r1 rsyncd

	# Install stunnel helpers
	if use stunnel ; then
		emake DESTDIR="${D}" install-ssl-client
		emake DESTDIR="${D}" install-ssl-daemon
	fi

	# Install the useful contrib scripts
	if use examples ; then
		exeinto /usr/share/rsync
		doexe support/*
		rm -f "${ED%/}"/usr/share/rsync/{Makefile*,*.c}
	fi

	eprefixify "${ED%/}"/etc/{,xinetd.d}/rsyncd*

	systemd_dounit "${FILESDIR}/rsyncd.service"
}

pkg_postinst() {
	if egrep -qis '^[[:space:]]use chroot[[:space:]]*=[[:space:]]*(no|0|false)' \
		"${EROOT}"/etc/rsyncd.conf "${EROOT}"/etc/rsync/rsyncd.conf ; then
		ewarn "You have disabled chroot support in your rsyncd.conf.  This"
		ewarn "is a security risk which you should fix.  Please check your"
		ewarn "/etc/rsyncd.conf file and fix the setting 'use chroot'."
	fi
	if use stunnel ; then
		einfo "Please install \">=net-misc/stunnel-4\" in order to use stunnel feature."
		einfo
		einfo "You maybe have to update the certificates configured in"
		einfo "${EROOT}/etc/stunnel/rsync.conf"
	fi
}
