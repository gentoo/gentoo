# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_ECLASS=cmake
inherit cmake flag-o-matic systemd tmpfiles

DESCRIPTION="Clam Anti-Virus Scanner"
HOMEPAGE="https://www.clamav.net/"
SRC_URI="https://www.clamav.net/downloads/production/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris ~x86-solaris"
IUSE="doc clamonacc clamapp libclamav-only milter rar selinux systemd test uclibc"

REQUIRED_USE="libclamav-only? ( !clamonacc !clamapp !milter )
			  clamonacc? ( clamapp )
			  milter? ( clamapp )"

RESTRICT="!test? ( test )"

# Require acct-{user,group}/clamav at build time so that we can set
# the permissions on /var/lib/clamav in src_install rather than in
# pkg_postinst; calling "chown" on the live filesystem scares me.
CDEPEND="acct-group/clamav
	acct-user/clamav
	dev-libs/libltdl
	dev-libs/libmspack
	dev-libs/libpcre2
	>=sys-libs/zlib-1.2.2:=
	app-arch/bzip2
	clamapp? ( sys-libs/ncurses:0 net-misc/curl dev-libs/json-c:= )
	elibc_musl? ( sys-libs/fts-standalone )
	virtual/libiconv
	!libclamav-only? ( net-misc/curl )
	dev-libs/openssl:0=
	milter? ( || ( mail-filter/libmilter mail-mta/sendmail ) )
	dev-libs/libxml2
	rar? ( app-arch/unrar )
	test? ( dev-python/pytest )"
# TODO: there is no way to use this with the new build system instead of the bundled one
#	dev-libs/tomsfastmath

BDEPEND=">=dev-util/cmake-3.14
	virtual/pkgconfig"

DEPEND="${CDEPEND}
	clamapp? ( dev-libs/json-c:* )
	test? ( dev-libs/check )"
RDEPEND="${CDEPEND}
	selinux? ( sec-policy/selinux-clamav )"

PATCHES=(
	"${FILESDIR}/${PN}-0.104.0-ncurses_detection.patch"
)

src_configure() {
	use elibc_musl && append-ldflags -lfts
	use ppc64 && append-flags -mminimal-toc
	use uclibc && export ac_cv_type_error_t=yes

	local mycmakeargs=(
		-DDATABASE_DIRECTORY="${EPREFIX}"/var/lib/clamav
		-DAPP_CONFIG_DIRECTORY="${EPREFIX}"/etc/clamav
		-DENABLE_EXPERIMENTAL=OFF
		-DENABLE_JSON_SHARED=ON
		-DENABLE_APP=$(usex clamapp ON OFF)
		-DENABLE_MILTER=$(usex milter ON OFF)
		-DENABLE_CLAMONACC=$(usex clamonacc ON OFF)
		-DCLAMAV_USER="clamav"
		-DCLAMAV_GROUP="clamav"
		-DBYTECODE_RUNTIME=interpreter
		-DOPTIMIZE=ON
		-DENABLE_EXTERNAL_MSPACK=ON
		-DENABLE_MAN_PAGES=ON
		-DENABLE_UNRAR=$(usex rar ON OFF)
		-DENABLE_TESTS=$(usex test ON OFF)
		-DENABLE_STATIC_LIB=OFF
		-DENABLE_SHARED_LIB=ON
		-DENABLE_SYSTEMD=$(usex systemd ON OFF)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	# init scripts
	newinitd "${FILESDIR}/clamd.initd" clamd
	newinitd "${FILESDIR}/freshclam.initd" freshclam
	use clamonacc && \
		newinitd "${FILESDIR}/clamonacc.initd" clamonacc
	use milter && \
		newinitd "${FILESDIR}/clamav-milter.initd" clamav-milter

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
			systemd_newunit "${FILESDIR}/clamd_at.service-0.104.0" "clamd@.service"
			systemd_dounit "${FILESDIR}/clamd.service"
			systemd_newunit "${FILESDIR}/freshclamd.service-r1" \
							"freshclamd.service"
		fi

		# Modify /etc/{clamd,freshclam}.conf to be usable out of the box
		sed -e "s:^\(Example\):\# \1:" \
			-e "s/^#\(PidFile .*\)/\1/" \
			-e "s/^#\(LocalSocket .*\)/\1/" \
			-e "s/^#\(User .*\)/\1/" \
			-e "s:^\#\(LogFile\) .*:\1 ${EPREFIX}/var/log/clamav/clamd.log:" \
			-e "s:^\#\(LogTime\).*:\1 yes:" \
			-e "s/^#\(DatabaseDirectory .*\)/\1/" \
			"${ED}"/etc/clamav/clamd.conf.sample > \
			"${ED}"/etc/clamav/clamd.conf || die

		sed -e "s:^\(Example\):\# \1:" \
			-e "s/^#\(PidFile .*\)/\1/" \
			-e "s/^#\(DatabaseOwner .*\)/\1/" \
			-e "s:^\#\(UpdateLogFile\) .*:\1 ${EPREFIX}/var/log/clamav/freshclam.log:" \
			-e "s:^\#\(NotifyClamd\).*:\1 ${EPREFIX}/etc/clamd.conf:" \
			-e "s:^\#\(ScriptedUpdates\).*:\1 yes:" \
			-e "s/^#\(DatabaseDirectory .*\)/\1/" \
			"${ED}"/etc/clamav/freshclam.conf.sample > \
			"${ED}"/etc/clamav/freshclam.conf || die

		if use milter ; then
			# Note: only keep the "unix" ClamdSocket and MilterSocket!
			sed -e "s:^\(Example\):\# \1:" \
				-e "s/^#\(PidFile .*\)/\1/" \
				-e "s/^#\(ClamdSocket unix:.*\)/\1/" \
				-e "s/^#\(User .*\)/\1/" \
				-e "s/^#\(MilterSocket unix:.*\)/\1/" \
				-e "s:^\#\(LogFile\) .*:\1 ${EPREFIX}/var/log/clamav/clamav-milter.log:" \
				"${ED}"/etc/clamav/clamav-milter.conf.sample > \
				"${ED}"/etc/clamav/clamav-milter.conf || die

			systemd_newunit "${FILESDIR}/clamav-milter.service-0.104.0" clamav-milter.service
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
