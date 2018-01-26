# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools eutils flag-o-matic user systemd

DESCRIPTION="Clam Anti-Virus Scanner"
HOMEPAGE="http://www.clamav.net/"
SRC_URI="https://www.clamav.net/downloads/production/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris ~x86-solaris"
IUSE="bzip2 clamdtop iconv ipv6 libressl milter metadata-analysis-api selinux static-libs uclibc"

CDEPEND="bzip2? ( app-arch/bzip2 )
	clamdtop? ( sys-libs/ncurses:0 )
	iconv? ( virtual/libiconv )
	metadata-analysis-api? ( dev-libs/json-c:= )
	milter? ( || ( mail-filter/libmilter mail-mta/sendmail ) )
	dev-libs/libtommath
	>=sys-libs/zlib-1.2.2:=
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	sys-devel/libtool
	|| ( dev-libs/libpcre2 >dev-libs/libpcre-6 )
	!!<app-antivirus/clamav-0.99"
# hard block clamav < 0.99 due to linking problems Bug #567680
# openssl is now *required* see this link as to why
# http://blog.clamav.net/2014/02/introducing-openssl-as-dependency-to.html
DEPEND="${CDEPEND}
	virtual/pkgconfig"
RDEPEND="${CDEPEND}
	selinux? ( sec-policy/selinux-clamav )"

DOCS=( AUTHORS BUGS ChangeLog FAQ INSTALL NEWS README UPGRADE )
PATCHES=(
	"${FILESDIR}"/${PN}-0.99.2-gcc-6.patch
	"${FILESDIR}"/${PN}-0.99.2-tinfo.patch
	"${FILESDIR}"/${PN}-0.99.2-bytecode_api.patch
	"${FILESDIR}"/${PN}-0.99.2-pcre2-compile-erroffset.patch
	"${FILESDIR}"/${PN}-0.99.3-fix-fd-leaks-in-cli_scanscript.patch
)

pkg_setup() {
	enewgroup clamav
	enewuser clamav -1 -1 /dev/null clamav
}

src_prepare() {
	default

	eautoconf
}

src_configure() {
	use ppc64 && append-flags -mminimal-toc
	use uclibc && export ac_cv_type_error_t=yes

	econf \
		$(use_enable bzip2) \
		$(use_enable clamdtop) \
		$(use_enable ipv6) \
		$(use_enable milter) \
		$(use_enable static-libs static) \
		$(use_with iconv) \
		$(use_with metadata-analysis-api libjson /usr) \
		--cache-file="${S}"/config.cache \
		--disable-experimental \
		--disable-gcc-vcheck \
		--disable-zlib-vcheck \
		--enable-id-check \
		--with-dbdir="${EPREFIX}"/var/lib/clamav \
		--with-system-tommath \
		--with-zlib="${EPREFIX}"/usr
}

src_install() {
	default

	rm -rf "${ED}"/var/lib/clamav
	newinitd "${FILESDIR}"/clamd.initd-r6 clamd
	newconfd "${FILESDIR}"/clamd.conf-r1 clamd

	systemd_dotmpfilesd "${FILESDIR}/tmpfiles.d/clamav.conf"
	systemd_newunit "${FILESDIR}/clamd_at.service" "clamd@.service"
	systemd_dounit "${FILESDIR}/clamd.service"
	systemd_dounit "${FILESDIR}/freshclamd.service"

	keepdir /var/lib/clamav
	fowners clamav:clamav /var/lib/clamav
	keepdir /var/log/clamav
	fowners clamav:clamav /var/log/clamav

	dodir /etc/logrotate.d
	insinto /etc/logrotate.d
	newins "${FILESDIR}"/clamav.logrotate clamav

	# Modify /etc/{clamd,freshclam}.conf to be usable out of the box
	sed -i -e "s:^\(Example\):\# \1:" \
		-e "s:.*\(PidFile\) .*:\1 ${EPREFIX}/var/run/clamav/clamd.pid:" \
		-e "s:.*\(LocalSocket\) .*:\1 ${EPREFIX}/var/run/clamav/clamd.sock:" \
		-e "s:.*\(User\) .*:\1 clamav:" \
		-e "s:^\#\(LogFile\) .*:\1 ${EPREFIX}/var/log/clamav/clamd.log:" \
		-e "s:^\#\(LogTime\).*:\1 yes:" \
		-e "s:^\#\(AllowSupplementaryGroups\).*:\1 yes:" \
		"${ED}"/etc/clamd.conf.sample || die
	sed -i -e "s:^\(Example\):\# \1:" \
		-e "s:.*\(PidFile\) .*:\1 ${EPREFIX}/var/run/clamav/freshclam.pid:" \
		-e "s:.*\(DatabaseOwner\) .*:\1 clamav:" \
		-e "s:^\#\(UpdateLogFile\) .*:\1 ${EPREFIX}/var/log/clamav/freshclam.log:" \
		-e "s:^\#\(NotifyClamd\).*:\1 ${EPREFIX}/etc/clamd.conf:" \
		-e "s:^\#\(ScriptedUpdates\).*:\1 yes:" \
		-e "s:^\#\(AllowSupplementaryGroups\).*:\1 yes:" \
		"${ED}"/etc/freshclam.conf.sample || die

	if use milter ; then
		# MilterSocket one to include ' /' because there is a 2nd line for
		# inet: which we want to leave
		dodoc "${FILESDIR}"/clamav-milter.README.gentoo
		sed -i -e "s:^\(Example\):\# \1:" \
			-e "s:.*\(PidFile\) .*:\1 ${EPREFIX}/var/run/clamav/clamav-milter.pid:" \
			-e "s+^\#\(ClamdSocket\) .*+\1 unix:${EPREFIX}/var/run/clamav/clamd.sock+" \
			-e "s:.*\(User\) .*:\1 clamav:" \
			-e "s+^\#\(MilterSocket\) /.*+\1 unix:${EPREFIX}/var/run/clamav/clamav-milter.sock+" \
			-e "s:^\#\(AllowSupplementaryGroups\).*:\1 yes:" \
			-e "s:^\#\(LogFile\) .*:\1 ${EPREFIX}/var/log/clamav/clamav-milter.log:" \
			"${ED}"/etc/clamav-milter.conf.sample || die
		cat >> "${ED}"/etc/conf.d/clamd <<-EOF
			MILTER_NICELEVEL=19
			START_MILTER=no
		EOF

		systemd_newunit "${FILESDIR}/clamav-milter.service-r1" clamav-milter.service
	fi

	for i in clamd freshclam clamav-milter
	do
		[[ -f "${D}"/etc/"${i}".conf.sample ]] && mv "${D}"/etc/"${i}".conf{.sample,}
	done

	prune_libtool_files --all
}

src_test() {
	emake quick-check
}

pkg_postinst() {
	if use milter ; then
		elog "For simple instructions how to setup the clamav-milter read the"
		elog "clamav-milter.README.gentoo in /usr/share/doc/${PF}"
	fi
	if test -z $(find "${ROOT}"var/lib/clamav -maxdepth 1 -name 'main.c*' -print -quit) ; then
		ewarn "You must run freshclam manually to populate the virus database files"
		ewarn "before starting clamav for the first time.\n"
	fi
}
