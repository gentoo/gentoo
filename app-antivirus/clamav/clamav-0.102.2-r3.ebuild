# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic systemd

DESCRIPTION="Clam Anti-Virus Scanner"
HOMEPAGE="https://www.clamav.net/"
SRC_URI="https://www.clamav.net/downloads/production/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris ~x86-solaris"
IUSE="bzip2 doc clamdtop clamsubmit iconv ipv6 libclamav-only libressl milter metadata-analysis-api selinux test uclibc xml"

REQUIRED_USE="libclamav-only? ( !clamdtop !clamsubmit !milter !metadata-analysis-api )"

RESTRICT="!test? ( test )"

# Require acct-{user,group}/clamav at build time so that we can set
# the permissions on /var/lib/clamav in src_install rather than in
# pkg_postinst; calling "chown" on the live filesystem scares me.
CDEPEND="acct-group/clamav
	acct-user/clamav
	dev-libs/libltdl
	dev-libs/libmspack
	|| ( dev-libs/libpcre2 >dev-libs/libpcre-6 )
	>=sys-libs/zlib-1.2.2:=
	bzip2? ( app-arch/bzip2 )
	clamdtop? ( sys-libs/ncurses:0 )
	clamsubmit? ( net-misc/curl dev-libs/json-c:= )
	elibc_musl? ( sys-libs/fts-standalone )
	iconv? ( virtual/libiconv )
	!libclamav-only? ( net-misc/curl )
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	metadata-analysis-api? ( dev-libs/json-c:= )
	milter? ( || ( mail-filter/libmilter mail-mta/sendmail ) )
	xml? ( dev-libs/libxml2 )"

BDEPEND="virtual/pkgconfig"

DEPEND="${CDEPEND}
	test? ( dev-libs/check )"
RDEPEND="${CDEPEND}
	selinux? ( sec-policy/selinux-clamav )"

PATCHES=(
	"${FILESDIR}/${PN}-0.101.2-tinfo.patch" #670729
	"${FILESDIR}/${PN}-0.102.1-libxml2_pkgconfig.patch" #661328
	"${FILESDIR}/${PN}-0.102.2-fix-curl-detection.patch" #709616
)

src_prepare() {
	default
	eautoconf

	if ! use clamsubmit; then
		# ENABLE_CLAMSUBMIT is defined in the configure script based on
		# only the values of $have_curl and $have_json (so we have no
		# easy way to disable it). Here we hack the configure script to
		# manually set the value of ENABLE_CLAMSUBMIT to something falsy
		# when USE=clamsubmit is not set. Yes, this looks backwards. The
		# value '#' is not a boolean indicator, it's a comment character.
		sed -e "s/ENABLE_CLAMSUBMIT_TRUE=$/ENABLE_CLAMSUBMIT_TRUE='#'/" \
			-e "s/ENABLE_CLAMSUBMIT_FALSE='#'/ENABLE_CLAMSUBMIT_FALSE=/" \
			-i configure \
			|| die 'failed to disable clamsubmit in ./configure script'
	fi
}

src_configure() {
	use elibc_musl && append-ldflags -lfts
	use ppc64 && append-flags -mminimal-toc
	use uclibc && export ac_cv_type_error_t=yes

	# according to configure help it should be
	# $(use_enable xml)
	# but that does not work
	# do not add this, since --disable-xml seems to override
	# --without-xml
	JSONCONF="--without-libjson"

	if use clamsubmit || use metadata-analysis-api; then
		# Either of these requires libjson-c.
		JSONCONF="--with-libjson=${EPREFIX}/usr"
	fi

	local myeconfargs=(
		$(use_enable bzip2)
		$(use_enable clamdtop)
		$(use_enable ipv6)
		$(use_enable milter)
		$(use_enable test check)
		$(use_with xml)
		$(use_with iconv)
		${JSONCONF}
		$(use_enable libclamav-only)
		$(use_with !libclamav-only libcurl)
		--with-system-libmspack
		--cache-file="${S}"/config.cache
		--disable-experimental
		--disable-static
		--disable-zlib-vcheck
		--enable-id-check
		--with-dbdir="${EPREFIX}"/var/lib/clamav
		# Don't call --with-zlib=/usr (see bug #699296)
		--with-zlib
		--disable-llvm
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default

	rm -rf "${ED}"/var/lib/clamav || die

	if ! use libclamav-only ; then
		newinitd "${FILESDIR}"/clamd.initd-r6 clamd
		newconfd "${FILESDIR}"/clamd.conf-r1 clamd

		systemd_dotmpfilesd "${FILESDIR}/tmpfiles.d/clamav.conf"
		systemd_newunit "${FILESDIR}/clamd_at.service" "clamd@.service"
		systemd_dounit "${FILESDIR}/clamd.service"
		systemd_dounit "${FILESDIR}/freshclamd.service"

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
			-e "s:^\#\(DatabaseDirectory\).*:\1 /var/lib/clamav:" \
			"${ED}"/etc/clamd.conf.sample || die

		sed -i -e "s:^\(Example\):\# \1:" \
			-e "s:.*\(PidFile\) .*:\1 ${EPREFIX}/var/run/clamav/freshclam.pid:" \
			-e "s:.*\(DatabaseOwner\) .*:\1 clamav:" \
			-e "s:^\#\(UpdateLogFile\) .*:\1 ${EPREFIX}/var/log/clamav/freshclam.log:" \
			-e "s:^\#\(NotifyClamd\).*:\1 ${EPREFIX}/etc/clamd.conf:" \
			-e "s:^\#\(ScriptedUpdates\).*:\1 yes:" \
			-e "s:^\#\(AllowSupplementaryGroups\).*:\1 yes:" \
			-e "s:^\#\(DatabaseDirectory\).*:\1 /var/lib/clamav:" \
			"${ED}"/etc/freshclam.conf.sample || die

		if use milter ; then
			# MilterSocket one to include ' /' because there is a 2nd line for
			# inet: which we want to leave
			##dodoc "${FILESDIR}"/clamav-milter.README.gentoo
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

		local i
		for i in clamd freshclam clamav-milter
		do
			if [[ -f "${ED}"/etc/"${i}".conf.sample ]]; then
				mv "${ED}"/etc/"${i}".conf{.sample,} || die
			fi
		done

		# These both need to be writable by the clamav user.
		# TODO: use syslog by default; that's what it's for.
		diropts -o clamav -g clamav
		keepdir /var/lib/clamav
		keepdir /var/log/clamav
	fi

	if use doc ; then
		local HTML_DOCS=( docs/html/. )
		einstalldocs

		if ! use libclamav-only ; then
			doman docs/man/*.[1-8]
		fi
	fi

	find "${ED}" -name '*.la' -delete || die
}

src_test() {
	if use libclamav-only ; then
		ewarn "Test target not available when USE=libclamav-only is set, skipping tests ..."
		return 0
	fi

	emake quick-check
}

pkg_postinst() {
	if use milter ; then
		elog "For simple instructions how to setup the clamav-milter read the"
		elog "clamav-milter.README.gentoo in /usr/share/doc/${PF}"
	fi

	local databases=( "${EROOT}"/var/lib/clamav/main.c[lv]d )
	if [[ ! -f "${databases}" ]] ; then
		ewarn "You must run freshclam manually to populate the virus database"
		ewarn "before starting clamav for the first time."
	fi

	elog "For instructions on how to use clamonacc, see"
	elog
	elog "  https://www.clamav.net/documents/on-access-scanning"
}
