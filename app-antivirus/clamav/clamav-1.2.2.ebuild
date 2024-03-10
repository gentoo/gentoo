# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
# Upstream are working on updating clamav's LLVM bytecode interpreter to work
# with later versions of LLVM, but it's not ready yet. See:
# https://github.com/Cisco-Talos/clamav/issues/581
# This does not impact the ability of the package to build with llvm/clang otherwise.
LLVM_MAX_SLOT=13
PYTHON_COMPAT=( python3_{10..12} )

CRATES="
	adler@1.0.2
	aho-corasick@1.0.5
	autocfg@1.1.0
	base64@0.21.3
	bindgen@0.65.1
	bit_field@0.10.2
	bitflags@1.3.2
	bitflags@2.4.0
	block-buffer@0.10.4
	bumpalo@3.13.0
	bytemuck@1.14.0
	byteorder@1.4.3
	cbindgen@0.25.0
	cc@1.0.83
	cexpr@0.6.0
	cfg-if@1.0.0
	clang-sys@1.6.1
	color_quant@1.1.0
	cpufeatures@0.2.9
	crc32fast@1.3.2
	crossbeam-channel@0.5.8
	crossbeam-deque@0.8.3
	crossbeam-epoch@0.9.15
	crossbeam-utils@0.8.16
	crunchy@0.2.2
	crypto-common@0.1.6
	digest@0.10.7
	either@1.9.0
	errno-dragonfly@0.1.2
	errno@0.3.3
	exr@1.7.0
	fastrand@2.0.0
	fdeflate@0.3.0
	flate2@1.0.27
	flume@0.10.14
	futures-core@0.3.28
	futures-sink@0.3.28
	generic-array@0.14.7
	getrandom@0.2.10
	gif@0.12.0
	glob@0.3.1
	half@2.2.1
	hashbrown@0.12.3
	heck@0.4.1
	hermit-abi@0.3.2
	hex@0.4.3
	home@0.5.5
	image@0.24.7
	indexmap@1.9.3
	itoa@1.0.9
	jpeg-decoder@0.3.0
	js-sys@0.3.64
	lazy_static@1.4.0
	lazycell@1.3.0
	lebe@0.5.2
	libc@0.2.147
	libloading@0.7.4
	linux-raw-sys@0.4.5
	lock_api@0.4.10
	log@0.4.20
	memchr@2.6.3
	memoffset@0.9.0
	minimal-lexical@0.2.1
	miniz_oxide@0.7.1
	nanorand@0.7.0
	nom@7.1.3
	num-complex@0.4.4
	num-integer@0.1.45
	num-rational@0.4.1
	num-traits@0.2.16
	num_cpus@1.16.0
	once_cell@1.18.0
	peeking_take_while@0.1.2
	pin-project-internal@1.1.3
	pin-project@1.1.3
	png@0.17.10
	prettyplease@0.2.15
	primal-check@0.3.3
	proc-macro2@1.0.66
	qoi@0.4.1
	quote@1.0.33
	rayon-core@1.11.0
	rayon@1.7.0
	redox_syscall@0.3.5
	regex-automata@0.3.8
	regex-syntax@0.7.5
	regex@1.9.5
	rustc-hash@1.1.0
	rustdct@0.7.1
	rustfft@6.1.0
	rustix@0.38.11
	ryu@1.0.15
	scopeguard@1.2.0
	serde@1.0.188
	serde_derive@1.0.188
	serde_json@1.0.105
	sha1@0.10.5
	sha2@0.10.7
	shlex@1.2.0
	simd-adler32@0.3.7
	smallvec@1.11.0
	spin@0.9.8
	strength_reduce@0.2.4
	syn@1.0.109
	syn@2.0.31
	tempfile@3.8.0
	thiserror-impl@1.0.48
	thiserror@1.0.48
	tiff@0.9.0
	toml@0.5.11
	transpose@0.2.2
	typenum@1.16.0
	unicode-ident@1.0.11
	unicode-segmentation@1.10.1
	version_check@0.9.4
	wasi@0.11.0+wasi-snapshot-preview1
	wasm-bindgen-backend@0.2.87
	wasm-bindgen-macro-support@0.2.87
	wasm-bindgen-macro@0.2.87
	wasm-bindgen-shared@0.2.87
	wasm-bindgen@0.2.87
	weezl@0.1.7
	which@4.4.2
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-sys@0.48.0
	windows-targets@0.48.5
	windows_aarch64_gnullvm@0.48.5
	windows_aarch64_msvc@0.48.5
	windows_i686_gnu@0.48.5
	windows_i686_msvc@0.48.5
	windows_x86_64_gnu@0.48.5
	windows_x86_64_gnullvm@0.48.5
	windows_x86_64_msvc@0.48.5
	zune-inflate@0.2.54
"

inherit cargo cmake flag-o-matic llvm python-any-r1 systemd tmpfiles

MY_P=${P//_/-}

DESCRIPTION="Clam Anti-Virus Scanner"
HOMEPAGE="https://www.clamav.net/"
SRC_URI="https://github.com/Cisco-Talos/clamav/archive/refs/tags/${MY_P}.tar.gz
	${CARGO_CRATE_URIS}"
S=${WORKDIR}/clamav-${MY_P}

LICENSE="Apache-2.0 BSD GPL-2 ISC MIT MPL-2.0 Unicode-DFS-2016 ZLIB"
# 0/sts (short term support) if not an LTS release
SLOT="0/sts"
if [[ ${PV} != *_rc* ]] ; then
	KEYWORDS="~alpha amd64 ~arm arm64 ppc ppc64 ~riscv ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
fi

IUSE="doc clamonacc +clamapp experimental jit libclamav-only milter rar selinux +system-mspack systemd test"

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
	dev-libs/libxml2
	dev-libs/openssl:=
	>=sys-libs/zlib-1.2.2:=
	virtual/libiconv
	!libclamav-only? ( net-misc/curl )
	clamapp? ( sys-libs/ncurses:= net-misc/curl )
	elibc_musl? ( sys-libs/fts-standalone )
	jit? ( <sys-devel/llvm-$((${LLVM_MAX_SLOT} + 1)):= )
	milter? ( mail-filter/libmilter:= )
	rar? ( app-arch/unrar )
	system-mspack? ( dev-libs/libmspack )
	test? ( dev-python/pytest )
"
# rust-bin < 1.71 has an executable stack
# which is not supported on selinux #911589
BDEPEND="
	virtual/pkgconfig
	>=virtual/rust-1.71
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

python_check_deps() {
	python_has_version -b "dev-python/pytest[${PYTHON_USEDEP}]"
}

pkg_setup() {
	use jit && llvm_pkg_setup
	use test && python-any-r1_pkg_setup
}

src_configure() {
	use elibc_musl && append-ldflags -lfts
	use ppc64 && append-flags -mminimal-toc

	local mycmakeargs=(
		-DAPP_CONFIG_DIRECTORY="${EPREFIX}"/etc/clamav
		-DBYTECODE_RUNTIME=$(usex jit llvm interpreter)
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
