# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic systemd tmpfiles

DESCRIPTION="Clam Anti-Virus Scanner"
HOMEPAGE="https://www.clamav.net/"
SRC_URI="https://www.clamav.net/downloads/production/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris ~x86-solaris"
IUSE="bzip2 doc clamonacc clamdtop clamsubmit iconv ipv6 libclamav-only milter metadata-analysis-api selinux systemd test uclibc xml"

REQUIRED_USE="libclamav-only? ( !clamonacc !clamdtop !clamsubmit !milter !metadata-analysis-api )"

RESTRICT="!test? ( test )"

# Require acct-{user,group}/clamav at build time so that we can set
# the permissions on /var/lib/clamav in src_install rather than in
# pkg_postinst; calling "chown" on the live filesystem scares me.
CDEPEND="acct-group/clamav
	acct-user/clamav
	dev-libs/libltdl
	dev-libs/libmspack
	|| ( dev-libs/libpcre2 >dev-libs/libpcre-6 )
	dev-libs/tomsfastmath
	>=sys-libs/zlib-1.2.2:=
	bzip2? ( app-arch/bzip2 )
	clamdtop? ( sys-libs/ncurses:0 )
	clamsubmit? ( net-misc/curl dev-libs/json-c:= )
	elibc_musl? ( sys-libs/fts-standalone )
	iconv? ( virtual/libiconv )
	!libclamav-only? ( net-misc/curl )
	dev-libs/openssl:0=
	milter? ( || ( mail-filter/libmilter mail-mta/sendmail ) )
	xml? ( dev-libs/libxml2 )"

# We need at least autoconf-2.69-r5 because that's the first (patched)
# version of it in Gentoo that supports ./configure --runstatedir.
BDEPEND=">=sys-devel/autoconf-2.69-r5
	virtual/pkgconfig"

DEPEND="${CDEPEND}
	metadata-analysis-api? ( dev-libs/json-c:* )
	test? ( dev-libs/check )"
RDEPEND="${CDEPEND}
	selinux? ( sec-policy/selinux-clamav )"

PATCHES=(
	"${FILESDIR}/${PN}-0.102.1-libxml2_pkgconfig.patch" #661328
	"${FILESDIR}/${PN}-0.102.2-fix-curl-detection.patch" #709616
	"${FILESDIR}/${PN}-0.103.0-system-tomsfastmath.patch" # 649394
	"${FILESDIR}/${PN}-0.103.1-upstream-openrc.patch"
)

src_prepare() {
	default

	# Be extra sure that we're using the system copy of tomsfastmath
	einfo "removing bundled copy of dev-libs/tomsfastmath"
	rm -r libclamav/tomsfastmath || \
		die "failed to remove bundled tomsfastmath"

	AT_NO_RECURSIVE="yes" eautoreconf
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
		$(use_enable clamonacc)
		$(use_enable clamdtop)
		$(use_enable ipv6)
		$(use_enable milter)
		$(use_enable test check)
		$(use_with xml)
		$(use_with iconv)
		${JSONUSE}
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
		--enable-openrc
		--runstatedir=/run
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default

	rm -rf "${ED}"/var/lib/clamav || die

	if ! use libclamav-only ; then
		if use systemd; then
			# The tmpfiles entry is behind USE=systemd because the
			# upstream OpenRC service files should (and do) ensure that
			# the directories they need exist and have the correct
			# permissions without the help of opentmpfiles. There are
			# years-old root exploits in opentmpfiles, the design is
			# fundamentally flawed, and the maintainer is not up to
			# the task of fixing it.
			dotmpfiles "${FILESDIR}/tmpfiles.d/clamav.conf"
			systemd_newunit "${FILESDIR}/clamd_at.service" "clamd@.service"
			systemd_dounit "${FILESDIR}/clamd.service"
			systemd_newunit "${FILESDIR}/freshclamd.service-r1" \
							"freshclamd.service"
		fi

		insinto /etc/logrotate.d
		newins "${FILESDIR}/clamd.logrotate" clamd
		newins "${FILESDIR}/freshclam.logrotate" freshclam
		use milter && \
			newins "${FILESDIR}/clamav-milter.logrotate-r1" clamav-milter

		# Modify /etc/{clamd,freshclam}.conf to be usable out of the box
		sed -i -e "s:^\(Example\):\# \1:" \
			-e "s/^#\(PidFile .*\)/\1/" \
			-e "s/^#\(LocalSocket .*\)/\1/" \
			-e "s/^#\(User .*\)/\1/" \
			-e "s:^\#\(LogFile\) .*:\1 ${EPREFIX}/var/log/clamav/clamd.log:" \
			-e "s:^\#\(LogTime\).*:\1 yes:" \
			-e "s/^#\(DatabaseDirectory .*\)/\1/" \
			"${ED}"/etc/clamd.conf.sample || die

		sed -i -e "s:^\(Example\):\# \1:" \
			-e "s/^#\(PidFile .*\)/\1/" \
			-e "s/^#\(DatabaseOwner .*\)/\1/" \
			-e "s:^\#\(UpdateLogFile\) .*:\1 ${EPREFIX}/var/log/clamav/freshclam.log:" \
			-e "s:^\#\(NotifyClamd\).*:\1 ${EPREFIX}/etc/clamd.conf:" \
			-e "s:^\#\(ScriptedUpdates\).*:\1 yes:" \
			-e "s/^#\(DatabaseDirectory .*\)/\1/" \
			"${ED}"/etc/freshclam.conf.sample || die

		if use milter ; then
			# Note: only keep the "unix" ClamdSocket and MilterSocket!
			sed -i -e "s:^\(Example\):\# \1:" \
				-e "s/^#\(PidFile .*\)/\1/" \
				-e "s/^#\(ClamdSocket unix:.*\)/\1/" \
				-e "s/^#\(User .*\)/\1/" \
				-e "s/^#\(MilterSocket unix:.*\)/\1/" \
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
	if ! use libclamav-only ; then
		if use systemd ; then
			tmpfiles_process clamav.conf
		fi
	fi

	if use milter ; then
		elog "For simple instructions how to setup the clamav-milter read the"
		elog "clamav-milter.README.gentoo in /usr/share/doc/${PF}"
	fi

	local databases=( "${EROOT}"/var/lib/clamav/main.c[lv]d )
	if [[ ! -f "${databases}" ]] ; then
		ewarn "You must run freshclam manually to populate the virus database"
		ewarn "before starting clamav for the first time."
	fi

	ewarn "This version of ClamAV provides separate OpenRC services"
	ewarn "for clamd, freshclam, clamav-milter, and clamonacc. The"
	ewarn "clamd service now starts only the clamd daemon itself. You"
	ewarn "should add freshclam (and perhaps clamav-milter) to any"
	ewarn "runlevels that previously contained clamd."
}
