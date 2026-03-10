# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{11..13} )
RUST_MIN_VER="1.87.0"

# Get the commit from the CLAM-2329-new-from-slice branch
declare -A GIT_CRATES=(
	[onenote_parser]='https://github.com/Cisco-Talos/onenote.rs;8b450447e58143004b68dd21c11b710fdb79be92;onenote.rs-%commit%'
)

inherit cargo cmake eapi9-ver flag-o-matic python-any-r1 systemd tmpfiles

MY_P=${P//_/-}

DESCRIPTION="Clam Anti-Virus Scanner"
HOMEPAGE="https://www.clamav.net/"
SRC_URI="https://github.com/Cisco-Talos/clamav/archive/refs/tags/${MY_P}.tar.gz
	https://deps.gentoo.zip/app-antivirus/clamav/${P}-crates.tar.xz
	${CARGO_CRATE_URIS}" # For the GIT_CRATES - use a crate tarball for everything else please.
S=${WORKDIR}/clamav-${MY_P}

LICENSE="Apache-2.0 BSD GPL-2 ISC MIT MPL-2.0 Unicode-DFS-2016 ZLIB"
# 0/sts (short term support) if not an LTS release (typically odd and even minor versions respectively)
if [[ $(( $(ver_cut 2) % 2 )) -eq 0 ]] ; then
	SLOT="0/lts"
else
	SLOT="0/sts"
fi

if [[ ${PV} != *_rc* ]] ; then
	KEYWORDS="~alpha amd64 ~arm arm64 ~ppc ppc64 ~riscv ~sparc ~x86"
fi

IUSE="doc clamonacc +clamapp experimental libclamav-only milter rar selinux +system-mspack systemd test"

REQUIRED_USE="libclamav-only? ( !clamonacc !clamapp !milter )
	clamonacc? ( clamapp )
	milter? ( clamapp )
	test? ( !libclamav-only )"

RESTRICT="!test? ( test )"

# Require acct-{user,group}/clamav at build time so that we can set
# the permissions on /var/lib/clamav in src_install rather than in
# pkg_postinst; calling "chown" on the live filesystem scares me.
COMMON_DEPEND="
	acct-group/clamav
	acct-user/clamav
	app-arch/bzip2
	dev-libs/json-c:=
	dev-libs/libltdl
	dev-libs/libpcre2:=
	dev-libs/libxml2:=
	dev-libs/openssl:=
	>=virtual/zlib-1.2.2:=
	virtual/libiconv
	!libclamav-only? ( net-misc/curl )
	clamapp? ( sys-libs/ncurses:= net-misc/curl )
	elibc_musl? ( sys-libs/fts-standalone )
	milter? ( mail-filter/libmilter:= )
	rar? ( app-arch/unrar )
	system-mspack? ( dev-libs/libmspack )
	test? ( dev-python/pytest )
"

BDEPEND="
	virtual/pkgconfig
	doc? ( app-text/doxygen )
	test? (
		${PYTHON_DEPS}
		$(python_gen_any_dep 'dev-python/pytest[${PYTHON_USEDEP}]')
	)
"

DEPEND="${COMMON_DEPEND}
	test? ( dev-libs/check )"

RDEPEND="${COMMON_DEPEND}
	selinux? ( sec-policy/selinux-clamav )"

PATCHES=(
	"${FILESDIR}/${PN}-1.4.1-pointer-types.patch"
)

python_check_deps() {
	python_has_version -b "dev-python/pytest[${PYTHON_USEDEP}]"
}

pkg_setup() {
	rust_pkg_setup
	use test && python-any-r1_pkg_setup
}

src_prepare() {
	cmake_src_prepare
}

src_configure() {
	use elibc_musl && append-ldflags -lfts
	use ppc64 && append-flags -mminimal-toc

	local mycmakeargs=(
		-DAPP_CONFIG_DIRECTORY="${EPREFIX}"/etc/clamav
		-DBYTECODE_RUNTIME="interpreter" # https://github.com/Cisco-Talos/clamav/issues/581 (does not support modern llvm)
		-DCLAMAV_GROUP="clamav"
		-DCLAMAV_USER="clamav"
		-DDATABASE_DIRECTORY="${EPREFIX}"/var/lib/clamav
		-DENABLE_APP=$(usex clamapp ON OFF)
		-DENABLE_CLAMONACC=$(usex clamonacc ON OFF)
		-DENABLE_DOXYGEN=$(usex doc)
		-DENABLE_EXPERIMENTAL=$(usex experimental ON OFF)
		-DENABLE_EXTERNAL_MSPACK=$(usex system-mspack ON OFF)
		-DENABLE_JSON_SHARED=ON
		-DENABLE_MAN_PAGES=ON
		-DENABLE_MILTER=$(usex milter ON OFF)
		-DENABLE_SHARED_LIB=ON
		-DENABLE_STATIC_LIB=OFF
		-DENABLE_SYSTEMD=$(usex systemd ON OFF)
		-DENABLE_TESTS=$(usex test ON OFF)
		-DENABLE_UNRAR=$(usex rar ON OFF)
		-DOPTIMIZE=ON
	)

	if use test ; then
		# https://bugs.gentoo.org/818673
		# Used to enable some more tests but doesn't behave well in
		# sandbox necessarily(?) + needs certain debug symbols present
		# in e.g. glibc.
		mycmakeargs+=(
			-DCMAKE_DISABLE_FIND_PACKAGE_Valgrind=ON
			-DPYTHON_FIND_VERSION="${EPYTHON#python}"
		)
	fi

	cmake_src_configure
}

src_install() {
	cmake_src_install
	# init scripts
	newinitd "${FILESDIR}/clamd.initd" clamd
	newinitd "${FILESDIR}/freshclam.initd" freshclam
	if use clamonacc; then
		newinitd "${FILESDIR}/clamonacc.initd.2" clamonacc
		newconfd "${FILESDIR}/clamonacc.confd" clamonacc
	fi
	use milter && \
		newinitd "${FILESDIR}/clamav-milter.initd" clamav-milter

	if ! use libclamav-only ; then
		if use systemd ; then
			# OpenRC services ensure their own permissions, so we can avoid
			# a dependency on sys-apps/systemd-utils[tmpfiles] here, though
			# we can change our minds and use it if we want to.
			dotmpfiles "${FILESDIR}/tmpfiles.d/clamav-r1.conf"
		fi

		if use clamapp ; then
			# Modify /etc/{clamd,freshclam}.conf to be usable out of the box
			local clamd_sed_args=(
				-e "s:^\(Example\):\# \1:"
				-e "s:^#\(PidFile\) .*:\1 ${EPREFIX}/run/clamd.pid:"
				-e "s/^#\(User .*\)/\1/"
				-e "s:^\#\(LogFile\) .*:\1 ${EPREFIX}/var/log/clamav/clamd.log:"
				-e "s:^\#\(LogTime\).*:\1 yes:"
				-e "s/^#\(DatabaseDirectory .*\)/\1/"
			)

			# 966587 - the systemd unit uses a different socket path
			if use systemd; then
				clamd_sed_args+=(
					-e "s:^#\(LocalSocket \)/run.*:\1${EPREFIX}/run/clamav/clamd.ctl:"
				)
			else
				clamd_sed_args+=(
					# There's one in /tmp that we don't want to default-enable
					-e "s:^#\(LocalSocket /run.*\):\1:"
				)
			fi

			sed "${clamd_sed_args[@]}" \
				"${ED}"/etc/clamav/clamd.conf.sample > \
				"${ED}"/etc/clamav/clamd.conf || die

			local freshclam_sed_args=(
				-e "s:^\(Example\):\# \1:"
				-e "s:^#\(PidFile\) .*:\1 ${EPREFIX}/run/freshclam.pid:"
				-e "s/^#\(DatabaseOwner .*\)/\1/"
				-e "s:^\#\(UpdateLogFile\) .*:\1 ${EPREFIX}/var/log/clamav/freshclam.log:"
				-e "s:^\#\(NotifyClamd\).*:\1 ${EPREFIX}/etc/clamav/clamd.conf:"
				-e "s:^\#\(ScriptedUpdates\).*:\1 yes:"
				-e "s/^#\(DatabaseDirectory .*\)/\1/"
			)
			sed "${freshclam_sed_args[@]}" \
				"${ED}"/etc/clamav/freshclam.conf.sample > \
				"${ED}"/etc/clamav/freshclam.conf || die

			if use milter ; then
				# Note: only keep the "unix" ClamdSocket and MilterSocket!
				local milter_sed_args=(
					-e "s:^\(Example\):\# \1:"
					-e "s:^\#\(PidFile\) .*:\1 ${EPREFIX}/run/clamav-milter.pid:"
					-e "s/^#\(ClamdSocket unix:.*\)/\1/"
					-e "s/^#\(User .*\)/\1/"
					-e "s:^\#\(LogFile\) .*:\1 ${EPREFIX}/var/log/clamav/clamav-milter.log:"
				)
				sed "${milter_sed_args[@]}" \
					"${ED}"/etc/clamav/clamav-milter.conf.sample > \
					"${ED}"/etc/clamav/clamav-milter.conf || die

				systemd_newunit "${FILESDIR}/clamav-milter.service-0.104.0" clamav-milter.service
			fi

			local i
			for i in clamd freshclam clamav-milter
			do
				if [[ -f "${ED}"/etc/"${i}".conf.sample ]] ; then
					mv "${ED}"/etc/"${i}".conf{.sample,} || die
				fi
			done

			# These both need to be writable by the clamav user
			# TODO: use syslog by default; that's what it's for.
			diropts -o clamav -g clamav
			keepdir /var/lib/clamav
			keepdir /var/log/clamav
		fi
	fi

	if use doc ; then
		local HTML_DOCS=( docs/html/. )
		einstalldocs
	fi

	# Don't install man pages for utilities we didn't install
	if use libclamav-only ; then
		rm -r "${ED}"/usr/share/man || die
	fi

	find "${ED}" -name '*.la' -delete || die
}

pkg_postinst() {
	if ! use libclamav-only ; then
		if use systemd ; then
			tmpfiles_process clamav-r1.conf
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

	if ! systemd_is_booted ; then
		ewarn "This version of ClamAV provides separate OpenRC services"
		ewarn "for clamd, freshclam, clamav-milter, and clamonacc. The"
		ewarn "clamd service now starts only the clamd daemon itself. You"
		ewarn "should add freshclam (and perhaps clamav-milter) to any"
		ewarn "runlevels that previously contained clamd."
	else
		if ver_replacing -le 1.3.1; then
			ewarn "From 1.3.1-r1 the Gentoo-provided systemd services have been"
			ewarn "Retired in favour of using the units shipped by upstream."
			ewarn "Ensure that any required services are configured and started."
			ewarn "clamd@.service has been retired as part of this transition."
		fi
	fi

	if [[ -z ${REPLACING_VERSIONS} ]] && use clamonacc; then
		einfo "'clamonacc' requires additional configuration before it"
		einfo "can be enabled, and may not produce any output if not properly"
		einfo "configured. Read the appropriate man page if clamonacc is desired."
	fi

}
