# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{11..13} )

CRATES="
	adler2@2.0.1
	adler32@1.2.0
	aho-corasick@1.1.3
	aligned-vec@0.6.4
	android_system_properties@0.1.5
	anstream@0.6.21
	anstyle-parse@0.2.7
	anstyle-query@1.1.4
	anstyle-wincon@3.0.10
	anstyle@1.0.13
	anyhow@1.0.100
	arbitrary@1.4.2
	arg_enum_proc_macro@0.3.4
	arrayvec@0.7.6
	autocfg@1.5.0
	av1-grain@0.2.4
	avif-serialize@0.8.6
	base64@0.21.7
	bindgen@0.65.1
	bit-set@0.5.3
	bit-vec@0.6.3
	bit_field@0.10.3
	bitflags@1.3.2
	bitflags@2.9.4
	bitstream-io@2.6.0
	block-buffer@0.10.4
	built@0.7.7
	bumpalo@3.19.0
	bytemuck@1.24.0
	byteorder-lite@0.1.0
	byteorder@1.5.0
	bytes@1.10.1
	bzip2-rs@0.1.2
	cbindgen@0.25.0
	cc@1.2.41
	cexpr@0.6.0
	cfg-expr@0.15.8
	cfg-if@1.0.3
	change-case@0.2.0
	chrono@0.4.42
	clang-sys@1.8.1
	clap@4.5.49
	clap_builder@4.5.49
	clap_derive@4.5.49
	clap_lex@0.7.6
	color_quant@1.1.0
	colorchoice@1.0.4
	core-foundation-sys@0.8.7
	cpufeatures@0.2.17
	crc32fast@1.5.0
	crossbeam-deque@0.8.6
	crossbeam-epoch@0.9.18
	crossbeam-utils@0.8.21
	crunchy@0.2.4
	crypto-common@0.1.6
	delharc@0.6.1
	digest@0.10.7
	displaydoc@0.2.5
	downcast-rs@2.0.2
	either@1.15.0
	either_n@0.2.0
	encoding_rs@0.8.35
	enum-primitive-derive@0.2.2
	enum-variants-strings-derive@0.3.0
	enum-variants-strings@0.3.0
	enumflags2@0.7.12
	enumflags2_derive@0.7.12
	equator-macro@0.4.2
	equator@0.4.2
	equivalent@1.0.2
	errno@0.3.14
	exr@1.73.0
	fancy-regex@0.3.5
	fastrand@2.3.0
	fax@0.2.6
	fax_derive@0.2.0
	fdeflate@0.3.7
	filetime@0.2.26
	find-msvc-tools@0.1.4
	flate2@1.1.4
	flexi_logger@0.30.2
	foreign-types-shared@0.1.1
	foreign-types@0.3.2
	form_urlencoded@1.2.2
	generic-array@0.14.9
	getrandom@0.2.16
	getrandom@0.3.3
	gif@0.13.3
	glob@0.3.3
	half@2.7.0
	hashbrown@0.12.3
	hashbrown@0.16.0
	heck@0.4.1
	heck@0.5.0
	hex-literal@0.4.1
	hex-literal@1.0.0
	hex@0.4.3
	home@0.5.11
	humantime@2.3.0
	iana-time-zone-haiku@0.1.2
	iana-time-zone@0.1.64
	icu_collections@2.0.0
	icu_locale_core@2.0.0
	icu_normalizer@2.0.0
	icu_normalizer_data@2.0.0
	icu_properties@2.0.1
	icu_properties_data@2.0.1
	icu_provider@2.0.0
	idna@1.1.0
	idna_adapter@1.2.1
	image-webp@0.2.4
	image@0.25.8
	imgref@1.12.0
	indexmap@1.9.3
	indexmap@2.11.4
	inflate@0.4.5
	interpolate_name@0.2.4
	is_terminal_polyfill@1.70.1
	itertools@0.10.5
	itertools@0.12.1
	itertools@0.14.0
	itoa@1.0.15
	jobserver@0.1.34
	js-sys@0.3.81
	lazy_static@1.5.0
	lazycell@1.3.0
	lebe@0.5.3
	libc@0.2.177
	libfuzzer-sys@0.4.10
	libloading@0.8.9
	libredox@0.1.10
	linux-raw-sys@0.11.0
	linux-raw-sys@0.4.15
	litemap@0.8.0
	log@0.4.28
	loop9@0.1.5
	maybe-rayon@0.1.1
	md5@0.7.0
	memchr@2.7.6
	minimal-lexical@0.2.1
	miniz_oxide@0.8.9
	moxcms@0.7.7
	new_debug_unreachable@1.0.6
	nom@7.1.3
	noop_proc_macro@0.3.0
	nu-ansi-term@0.50.3
	num-bigint@0.4.6
	num-complex@0.4.6
	num-derive@0.4.2
	num-integer@0.1.46
	num-rational@0.4.2
	num-traits@0.2.19
	once_cell@1.21.3
	once_cell_polyfill@1.70.1
	openssl-macros@0.1.1
	openssl-sys@0.9.109
	openssl@0.10.73
	paste@1.0.15
	peeking_take_while@0.1.2
	percent-encoding@2.3.2
	pkg-config@0.3.32
	png@0.18.0
	potential_utf@0.1.3
	ppv-lite86@0.2.21
	prettyplease@0.2.37
	primal-check@0.3.4
	proc-macro2@1.0.101
	profiling-procmacros@1.0.17
	profiling@1.0.17
	pxfm@0.1.25
	qoi@0.4.1
	quick-error@2.0.1
	quote@1.0.41
	r-efi@5.3.0
	rand@0.8.5
	rand_chacha@0.3.1
	rand_core@0.6.4
	rav1e@0.7.1
	ravif@0.11.20
	rayon-core@1.13.0
	rayon@1.11.0
	redox_syscall@0.5.18
	regex-automata@0.4.13
	regex-syntax@0.8.8
	regex@1.12.2
	rgb@0.8.52
	rustc-hash@1.1.0
	rustdct@0.7.1
	rustfft@6.4.1
	rustix@0.38.44
	rustix@1.1.2
	rustversion@1.0.22
	ryu@1.0.20
	serde@1.0.228
	serde_core@1.0.228
	serde_derive@1.0.228
	serde_json@1.0.145
	serde_spanned@0.6.9
	sha1@0.10.6
	sha2@0.10.9
	shlex@1.3.0
	simd-adler32@0.3.7
	simd_helpers@0.1.0
	smallvec@1.15.1
	stable_deref_trait@1.2.1
	strength_reduce@0.2.4
	string-cases@0.2.0
	strsim@0.11.1
	strum@0.27.2
	strum_macros@0.27.2
	syn@1.0.109
	syn@2.0.106
	synstructure@0.13.2
	system-deps@6.2.2
	tar@0.4.44
	target-lexicon@0.12.16
	tempfile@3.23.0
	thiserror-impl@1.0.69
	thiserror-impl@2.0.17
	thiserror@1.0.69
	thiserror@2.0.17
	tiff@0.10.3
	tinystr@0.8.1
	tinyvec@1.10.0
	tinyvec_macros@0.1.1
	toml@0.5.11
	toml@0.8.23
	toml_datetime@0.6.11
	toml_edit@0.22.27
	transpose@0.2.3
	typenum@1.19.0
	unicode-ident@1.0.19
	unicode-segmentation@1.12.0
	url@2.5.7
	utf8_iter@1.0.4
	utf8parse@0.2.2
	uuid@1.18.1
	v_frame@0.3.9
	vcpkg@0.2.15
	version-compare@0.2.0
	version_check@0.9.5
	wasi@0.11.1+wasi-snapshot-preview1
	wasi@0.14.7+wasi-0.2.4
	wasip2@1.0.1+wasi-0.2.4
	wasm-bindgen-backend@0.2.104
	wasm-bindgen-macro-support@0.2.104
	wasm-bindgen-macro@0.2.104
	wasm-bindgen-shared@0.2.104
	wasm-bindgen@0.2.104
	weezl@0.1.10
	which@4.4.2
	widestring@1.2.1
	windows-core@0.62.2
	windows-implement@0.60.2
	windows-interface@0.59.3
	windows-link@0.2.1
	windows-result@0.4.1
	windows-strings@0.5.1
	windows-sys@0.59.0
	windows-sys@0.60.2
	windows-sys@0.61.2
	windows-targets@0.52.6
	windows-targets@0.53.5
	windows_aarch64_gnullvm@0.52.6
	windows_aarch64_gnullvm@0.53.1
	windows_aarch64_msvc@0.52.6
	windows_aarch64_msvc@0.53.1
	windows_i686_gnu@0.52.6
	windows_i686_gnu@0.53.1
	windows_i686_gnullvm@0.52.6
	windows_i686_gnullvm@0.53.1
	windows_i686_msvc@0.52.6
	windows_i686_msvc@0.53.1
	windows_x86_64_gnu@0.52.6
	windows_x86_64_gnu@0.53.1
	windows_x86_64_gnullvm@0.52.6
	windows_x86_64_gnullvm@0.53.1
	windows_x86_64_msvc@0.52.6
	windows_x86_64_msvc@0.53.1
	winnow@0.7.13
	wit-bindgen@0.46.0
	writeable@0.6.1
	xattr@1.6.1
	yoke-derive@0.8.0
	yoke@0.8.0
	zerocopy-derive@0.8.27
	zerocopy@0.8.27
	zerofrom-derive@0.1.6
	zerofrom@0.1.6
	zerotrie@0.2.2
	zerovec-derive@0.11.1
	zerovec@0.11.4
	zune-core@0.4.12
	zune-inflate@0.2.54
	zune-jpeg@0.4.21
"

declare -A GIT_CRATES=(
	[clam-sigutil]='https://github.com/Cisco-Talos/clamav-signature-util;7cfeb7f630ce472239f5b0a794b62df7f592acc7;clamav-signature-util-%commit%'
	[onenote_parser]='https://github.com/Cisco-Talos/onenote.rs;29c08532252b917543ff268284f926f30876bb79;onenote.rs-%commit%'
)

inherit cargo cmake eapi9-ver flag-o-matic python-any-r1 systemd tmpfiles

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
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~sparc ~x86"
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
	use clamonacc && \
		newinitd "${FILESDIR}/clamonacc.initd" clamonacc
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
			sed -e "s:^\(Example\):\# \1:" \
				-e "s:^#\(PidFile\) .*:\1 ${EPREFIX}/run/clamd.pid:" \
				-e "s/^#\(LocalSocket .*\)/\1/" \
				-e "s/^#\(User .*\)/\1/" \
				-e "s:^\#\(LogFile\) .*:\1 ${EPREFIX}/var/log/clamav/clamd.log:" \
				-e "s:^\#\(LogTime\).*:\1 yes:" \
				-e "s/^#\(DatabaseDirectory .*\)/\1/" \
				"${ED}"/etc/clamav/clamd.conf.sample > \
				"${ED}"/etc/clamav/clamd.conf || die

			sed -e "s:^\(Example\):\# \1:" \
				-e "s:^#\(PidFile\) .*:\1 ${EPREFIX}/run/freshclam.pid:" \
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
					-e "s:^\#\(PidFile\) .*:\1 ${EPREFIX}/run/clamav-milter.pid:" \
					-e "s/^#\(ClamdSocket unix:.*\)/\1/" \
					-e "s/^#\(User .*\)/\1/" \
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
