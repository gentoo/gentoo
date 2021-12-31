# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools eutils flag-o-matic ltprune systemd

DESCRIPTION="Clam Anti-Virus Scanner"
HOMEPAGE="https://www.clamav.net/"
SRC_URI="https://www.clamav.net/downloads/production/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ia64 ppc ppc64 ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris ~x86-solaris"
IUSE="bzip2 doc clamdtop clamsubmit iconv ipv6 libclamav-only libressl milter metadata-analysis-api selinux static-libs test uclibc xml"
RESTRICT="!test? ( test )"

# Require acct-{user,group}/clamav at build time so that we can set
# the permissions on /var/lib/clamav in src_install rather than in
# pkg_postinst; calling "chown" on the live filesystem scares me.
CDEPEND="acct-group/clamav
	acct-user/clamav
	bzip2? ( app-arch/bzip2 )
	clamdtop? ( sys-libs/ncurses:0 )
	iconv? ( virtual/libiconv )
	metadata-analysis-api? ( dev-libs/json-c:= )
	milter? ( || ( mail-filter/libmilter mail-mta/sendmail ) )
	>=sys-libs/zlib-1.2.2:=
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	dev-libs/libltdl
	|| ( dev-libs/libpcre2 >dev-libs/libpcre-6 )
	dev-libs/libmspack
	xml? ( dev-libs/libxml2 )
	elibc_musl? ( sys-libs/fts-standalone )
	!libclamav-only? ( net-misc/curl )
	clamsubmit? ( net-misc/curl dev-libs/json-c:=  )
	!!<app-antivirus/clamav-0.99"
REQUIRED_USE="
	libclamav-only? ( !clamsubmit )
	clamsubmit? ( !libclamav-only )
"
# hard block clamav < 0.99 due to linking problems Bug #567680
# openssl is now *required* see this link as to why
# https://blog.clamav.net/2014/02/introducing-openssl-as-dependency-to.html
DEPEND="${CDEPEND}
	virtual/pkgconfig
	test? ( dev-libs/check )"
RDEPEND="${CDEPEND}
	selinux? ( sec-policy/selinux-clamav )"

HTML_DOCS=( docs/html/. )

PATCHES=(
	"${FILESDIR}/${PN}-0.101.2-tinfo.patch" #670729
	"${FILESDIR}/${PN}-0.102.1-libxml2_pkgconfig.patch" #661328
)

src_prepare() {
	default
	eautoconf
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
	JSONUSE="--without-libjson"

	if use clamsubmit || use metadata-analysis-api; then
		# either of those 2 requires libjson.
		# clamsubmit will be built as soon as libjson and curl are found
		# but we only install the binary if requested
		JSONUSE="--with-libjson=${EPREFIX}/usr"
	fi

	local myeconfargs=(
		$(use_enable bzip2)
		$(use_enable clamdtop)
		$(use_enable ipv6)
		$(use_enable milter)
		$(use_enable static-libs static)
		$(use_enable test check)
		$(use_with xml)
		$(use_with iconv)
		${JSONUSE}
		$(use_enable libclamav-only)
		$(use_with !libclamav-only libcurl)
		--with-system-libmspack
		--cache-file="${S}"/config.cache
		--disable-experimental
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

	rm -rf "${ED}"/var/lib/clamav
	newinitd "${FILESDIR}"/clamd.initd-r6 clamd
	newconfd "${FILESDIR}"/clamd.conf-r1 clamd

	systemd_dotmpfilesd "${FILESDIR}/tmpfiles.d/clamav.conf"
	systemd_newunit "${FILESDIR}/clamd_at.service" "clamd@.service"
	systemd_dounit "${FILESDIR}/clamd.service"
	systemd_dounit "${FILESDIR}/freshclamd.service"

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

	if use doc; then
	   einstalldocs
	   doman docs/man/*.[1-8]
	fi

	for i in clamd freshclam clamav-milter
	do
		[[ -f "${D}"/etc/"${i}".conf.sample ]] && mv "${D}"/etc/"${i}".conf{.sample,}
	done

	prune_libtool_files --all

	# These both need to be writable by the clamav user.
	# TODO: use syslog by default; that's what it's for.
	diropts -o clamav -g clamav
	keepdir /var/lib/clamav
	keepdir /var/log/clamav
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
	elog "For instructions on how to use clamonacc see https://www.clamav.net/documents/on-access-scanning"
}
