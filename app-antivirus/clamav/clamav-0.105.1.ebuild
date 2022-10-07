# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_MAX_SLOT=13
PYTHON_COMPAT=( python3_{8..11} )
inherit cmake flag-o-matic llvm python-any-r1 systemd tmpfiles

DESCRIPTION="Clam Anti-Virus Scanner"
HOMEPAGE="https://www.clamav.net/"
SRC_URI="https://www.clamav.net/downloads/production/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris ~x86-solaris"
IUSE="doc clamonacc +clamapp experimental jit libclamav-only milter rar selinux systemd test"

REQUIRED_USE="libclamav-only? ( !clamonacc !clamapp !milter )
	clamonacc? ( clamapp )
	milter? ( clamapp )
	test? ( !libclamav-only )"

RESTRICT="!test? ( test )"

# Require acct-{user,group}/clamav at build time so that we can set
# the permissions on /var/lib/clamav in src_install rather than in
# pkg_postinst; calling "chown" on the live filesystem scares me.
CDEPEND="
	acct-group/clamav
	acct-user/clamav
	app-arch/bzip2
	dev-libs/json-c:=
	dev-libs/libltdl
	dev-libs/libmspack
	dev-libs/libpcre2:=
	dev-libs/libxml2
	dev-libs/openssl:=
	dev-libs/tomsfastmath:=
	>=sys-libs/zlib-1.2.2:=
	virtual/libiconv
	!libclamav-only? ( net-misc/curl )
	clamapp? ( sys-libs/ncurses:= net-misc/curl )
	elibc_musl? ( sys-libs/fts-standalone )
	jit? ( <sys-devel/llvm-$((${LLVM_MAX_SLOT} + 1)):= )
	milter? ( mail-filter/libmilter:= )
	rar? ( app-arch/unrar )
	test? ( dev-python/pytest )
"

BDEPEND="
	virtual/pkgconfig
	>=virtual/rust-1.56
	doc? ( app-doc/doxygen )
	test? (
		${PYTHON_DEPS}
		$(python_gen_any_dep 'dev-python/pytest[${PYTHON_USEDEP}]')
	)
"

DEPEND="${CDEPEND}
	test? ( dev-libs/check )"

RDEPEND="${CDEPEND}
	selinux? ( sec-policy/selinux-clamav )"

python_check_deps() {
	python_has_version -b "dev-python/pytest[${PYTHON_USEDEP}]"
}

pkg_setup() {
	use jit && llvm_pkg_setup
	use test && python-any-r1_pkg_setup
}

PATCHES=(
	"${FILESDIR}/${P}-cmake-llvm-fix.patch"
)

src_configure() {
	use elibc_musl && append-ldflags -lfts
	use ppc64 && append-flags -mminimal-toc

	local mycmakeargs=(
		-DDATABASE_DIRECTORY="${EPREFIX}"/var/lib/clamav
		-DAPP_CONFIG_DIRECTORY="${EPREFIX}"/etc/clamav
		-DENABLE_EXPERIMENTAL=$(usex experimental ON OFF)
		-DENABLE_JSON_SHARED=ON
		-DENABLE_APP=$(usex clamapp ON OFF)
		-DENABLE_MILTER=$(usex milter ON OFF)
		-DENABLE_CLAMONACC=$(usex clamonacc ON OFF)
		-DCLAMAV_USER="clamav"
		-DCLAMAV_GROUP="clamav"
		-DBYTECODE_RUNTIME=$(usex jit llvm interpreter)
		-DOPTIMIZE=ON
		-DENABLE_EXTERNAL_MSPACK=ON
		-DENABLE_EXTERNAL_TOMSFASTMATH=ON
		-DENABLE_MAN_PAGES=ON
		-DENABLE_DOXYGEN=$(usex doc)
		-DENABLE_UNRAR=$(usex rar ON OFF)
		-DENABLE_TESTS=$(usex test ON OFF)
		-DENABLE_STATIC_LIB=OFF
		-DENABLE_SHARED_LIB=ON
		-DENABLE_SYSTEMD=$(usex systemd ON OFF)
	)

	if use test ; then
		# https://bugs.gentoo.org/818673
		# Used to enable some more tests but doesn't behave well in
		# sandbox necessarily(?) + needs certain debug symbols present
		# in e.g. glibc.
		mycmakeargs+=( -DCMAKE_DISABLE_FIND_PACKAGE_Valgrind=ON )
	fi

	if use jit ; then
		# Suppress CMake warnings that variables aren't consumed if we aren't using LLVM
		# https://github.com/Cisco-Talos/clamav/blob/main/INSTALL.md#llvm-optional-see-bytecode-runtime-section
		# https://github.com/Cisco-Talos/clamav/blob/main/INSTALL.md#bytecode-runtime
		mycmakeargs+=(
			-DLLVM_ROOT_DIR="$(get_llvm_prefix -d ${LLVM_MAX_SLOT})"
			-DLLVM_FIND_VERSION="$(best_version sys-devel/llvm:${LLVM_MAX_SLOT} | cut -c 16-)"
		)
	fi

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
		if use systemd ; then
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

		if use clamapp ; then
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
				-e "s:^\#\(NotifyClamd\).*:\1 ${EPREFIX}/etc/clamav/clamd.conf:" \
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
				if [[ -f "${ED}"/etc/"${i}".conf.sample ]] ; then
					mv "${ED}"/etc/"${i}".conf{.sample,} || die
				fi
			done

			# These both need to be writable by the clamav user.
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

	 if ! systemd_is_booted ; then
		ewarn "This version of ClamAV provides separate OpenRC services"
		ewarn "for clamd, freshclam, clamav-milter, and clamonacc. The"
		ewarn "clamd service now starts only the clamd daemon itself. You"
		ewarn "should add freshclam (and perhaps clamav-milter) to any"
		ewarn "runlevels that previously contained clamd."
	fi
}
