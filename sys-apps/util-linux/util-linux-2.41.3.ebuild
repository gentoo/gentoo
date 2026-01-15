# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
TMPFILES_OPTIONAL=1

inherit toolchain-funcs libtool flag-o-matic bash-completion-r1 \
	pam python-r1 multilib-minimal multiprocessing systemd tmpfiles

MY_PV="${PV/_/-}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="Various useful Linux utilities"
HOMEPAGE="https://www.kernel.org/pub/linux/utils/util-linux/ https://github.com/util-linux/util-linux"

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://git.kernel.org/pub/scm/utils/util-linux/util-linux.git"
	inherit autotools git-r3
else
	VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/karelzak.asc
	inherit verify-sig

	if [[ ${PV} != *_rc* ]] ; then
		KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~arm64-macos"
	fi

	SRC_URI="https://www.kernel.org/pub/linux/utils/util-linux/v${PV:0:4}/${MY_P}.tar.xz"
	SRC_URI+=" verify-sig? ( https://www.kernel.org/pub/linux/utils/util-linux/v${PV:0:4}/${MY_P}.tar.sign )"
fi

S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2 GPL-3 LGPL-2.1 BSD-4 MIT public-domain"
SLOT="0"
IUSE="audit build caps +cramfs cryptsetup fdformat +hardlink kill +logger magic ncurses nls pam python +readline rtas selinux slang static-libs +su +suid systemd test tty-helpers udev unicode uuidd"

# Most lib deps here are related to programs rather than our libs,
# so we rarely need to specify ${MULTILIB_USEDEP}.
RDEPEND="
	virtual/libcrypt:=
	audit? ( >=sys-process/audit-2.6:= )
	caps? ( sys-libs/libcap-ng )
	cramfs? ( virtual/zlib:= )
	cryptsetup? ( >=sys-fs/cryptsetup-2.1.0 )
	hardlink? ( dev-libs/libpcre2:= )
	ncurses? (
		sys-libs/ncurses:=[unicode(+)?]
		magic? ( sys-apps/file:0= )
	)
	nls? ( virtual/libintl[${MULTILIB_USEDEP}] )
	pam? ( sys-libs/pam )
	python? ( ${PYTHON_DEPS} )
	readline? ( sys-libs/readline:0= )
	rtas? ( sys-libs/librtas )
	selinux? ( >=sys-libs/libselinux-2.2.2-r4[${MULTILIB_USEDEP}] )
	slang? ( sys-libs/slang )
	!build? (
		systemd? ( sys-apps/systemd )
		udev? ( virtual/libudev:= )
	)
"
BDEPEND="
	virtual/pkgconfig
	nls? (
		app-text/po4a
		sys-devel/gettext
	)
	test? ( app-alternatives/bc )
"
DEPEND="
	${RDEPEND}
	virtual/os-headers
	acct-group/root
"
RDEPEND+="
	hardlink? ( !app-arch/hardlink )
	logger? ( !>=app-admin/sysklogd-2.0[logger] )
	kill? (
		!sys-apps/coreutils[kill]
		!sys-process/procps[kill]
	)
	su? (
		!<sys-apps/shadow-4.7-r2
		!>=sys-apps/shadow-4.7-r2[su]
	)
	uuidd? (
		acct-user/uuidd
		systemd? ( virtual/tmpfiles )
	)
	!net-wireless/rfkill
"

if [[ ${PV} == 9999 ]] ; then
	# Required for man-page generation
	BDEPEND+=" dev-ruby/asciidoctor"
else
	BDEPEND+=" verify-sig? ( >=sec-keys/openpgp-keys-karelzak-20230517 )"
fi

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} ) su? ( pam )"
RESTRICT="!test? ( test )"

pkg_pretend() {
	if use su && ! use suid ; then
		elog "su will be installed as suid despite USE=-suid (bug #832092)"
		elog "To use su without suid, see e.g. Portage's suidctl feature."
	fi
}

src_unpack() {
	if [[ ${PV} == 9999 ]] ; then
		git-r3_src_unpack
		return
	fi

	if use verify-sig; then
		verify-sig_uncompress_verify_unpack "${DISTDIR}"/${MY_P}.tar.xz \
			"${DISTDIR}"/${MY_P}.tar.sign
	else
		default
	fi
}

src_prepare() {
	default

	if use test ; then
		# Known-failing tests
		local known_failing_tests=(
			# Subtest 'options-maximum-size-8192' fails
			hardlink/options

			# Fails in sandbox
			# re ioctl_ns: https://github.com/util-linux/util-linux/issues/2967
			lsns/ioctl_ns
			lsfd/mkfds-inotify
			lsfd/mkfds-symlink
			lsfd/mkfds-rw-character-device
			# Fails with network-sandbox at least in nspawn
			lsfd/option-inet
			utmp/last-ipv6

			# Fails with permission errors in nspawn
			fadvise/drop
			fincore/count

			# Flaky
			rename/subdir

			# Permission issues on /dev/random
			lsfd/mkfds-eventpoll
			lsfd/column-xmode

			# Hangs on some machines
			script/replay
		)

		# debug prints confuse the tests which look for a diff
		# in output
		if has_version "=app-shells/bash-5.3_alpha*" ; then
			known_failing_tests+=(
				lsfd/column-ainodeclass
				lsfd/mkfds-netlink-protocol
				lsfd/column-type
				lsfd/mkfds-eventfd
				lsfd/mkfds-signalfd
				lsfd/mkfds-mqueue
				lsfd/mkfds-tcp6
				lsfd/mkfds-tcp
				lsfd/filter-floating-point-nums
				lsfd/mkfds-unix-stream-requiring-sockdiag
				lsfd/mkfds-unix-dgram
				lsfd/mkfds-directory
				lsfd/mkfds-pty
				lsfd/mkfds-pipe-no-fork
				lsfd/mkfds-unix-stream
				lsfd/mkfds-ro-regular-file
				lsfd/mkfds-timerfd
				lsfd/mkfds-udp
				lsfd/mkfds-udp6
			)
		fi

		local known_failing_test
		for known_failing_test in "${known_failing_tests[@]}" ; do
			einfo "Removing known-failing test: ${known_failing_test}"
			rm tests/ts/${known_failing_test} || die
		done
	fi

	if [[ ${PV} == 9999 ]] ; then
		po/update-potfiles
		eautoreconf
	else
		elibtoolize
	fi
}

python_configure() {
	local myeconfargs=(
		"${commonargs[@]}"
		--disable-all-programs
		--disable-bash-completion
		--without-systemdsystemunitdir
		--with-python
		--enable-libblkid
		--enable-libmount
		--enable-pylibmount
	)

	mkdir "${BUILD_DIR}" || die
	pushd "${BUILD_DIR}" >/dev/null || die
	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
	popd >/dev/null || die
}

multilib_src_configure() {
	# The scanf test in a run-time test which fails while cross-compiling.
	# Blindly assume a POSIX setup since we require libmount, and libmount
	# itself fails when the scanf test fails. bug #531856
	tc-is-cross-compiler && export scanf_cv_alloc_modifier=ms

	# bug #485486
	export ac_cv_header_security_pam_misc_h=$(multilib_native_usex pam)
	# bug #545042
	export ac_cv_header_security_pam_appl_h=$(multilib_native_usex pam)

	# Undo bad ncurses handling by upstream. Fall back to pkg-config.
	# bug #601530
	export NCURSES6_CONFIG=false NCURSES5_CONFIG=false
	export NCURSESW6_CONFIG=false NCURSESW5_CONFIG=false

	# Avoid automagic dependency on ppc*
	export ac_cv_lib_rtas_rtas_get_sysparm=$(usex rtas)

	# configure args shared by python and non-python builds
	local commonargs=(
		--localstatedir="${EPREFIX}/var"
		--runstatedir="${EPREFIX}/run"
		--enable-fs-paths-extra="${EPREFIX}/usr/sbin:${EPREFIX}/bin:${EPREFIX}/usr/bin"
	)

	local myeconfargs=(
		"${commonargs[@]}"
		--with-bashcompletiondir="$(get_bashcompdir)"
		--without-python
		$(multilib_native_use_enable suid makeinstall-chown)
		$(multilib_native_use_enable suid makeinstall-setuid)
		$(multilib_native_use_with readline)
		$(multilib_native_use_with slang)
		$(multilib_native_usex ncurses "$(use_with magic libmagic)" '--without-libmagic')
		$(multilib_native_usex ncurses "$(use_with unicode ncursesw)" '--without-ncursesw')
		$(multilib_native_usex ncurses "$(use_with !unicode ncurses)" '--without-ncurses')
		$(multilib_native_use_with audit)
		$(tc-has-tls || echo --disable-tls)
		$(use_enable nls)
		$(use_enable nls poman)
		$(use_enable unicode widechar)
		$(use_enable static-libs static)
		$(use_with ncurses tinfo)
		$(use_with selinux)
		$(multilib_native_use_enable uuidd)

		# TODO: Wire this up (bug #931118)
		--without-econf

		# TODO: Wire this up (bug #931297)
		# TODO: investigate build failure w/ 2.40.1_rc1
		--disable-liblastlog2
		--disable-pam-lastlog2
	)

	if use build ; then
		myeconfargs+=(
			--without-systemd
			--without-udev
		)
	else
		myeconfargs+=(
			$(multilib_native_use_with systemd)
			$(multilib_native_use_with udev)
		)
	fi

	if multilib_is_native_abi ; then
		myeconfargs+=(
			--disable-chfn-chsh
			--disable-login
			--disable-newgrp
			--disable-nologin
			--disable-pylibmount
			--disable-raw
			--disable-vipw
			--enable-agetty
			--enable-bash-completion
			--enable-line
			--enable-partx
			--enable-rename
			--enable-rfkill
			--enable-schedutils
			--with-systemdsystemunitdir="$(systemd_get_systemunitdir)"
			--with-tmpfilesdir="${EPREFIX}"/usr/lib/tmpfiles.d
			$(use_enable caps setpriv)
			$(use_enable cramfs)
			$(use_enable fdformat)
			$(use_enable hardlink)
			$(use_enable kill)
			$(use_enable logger)
			$(use_enable ncurses pg)
			$(use_enable su)
			$(use_enable tty-helpers mesg)
			$(use_enable tty-helpers wall)
			$(use_enable tty-helpers write)
			$(use_with cryptsetup)
		)
		if [[ ${PV} == *9999 ]] ; then
			myeconfargs+=( --enable-asciidoc )
		else
			# Upstream is shipping pre-generated man-pages for releases
			myeconfargs+=( --disable-asciidoc )
		fi
	else
		myeconfargs+=(
			--disable-all-programs
			--disable-asciidoc
			--disable-bash-completion
			--without-systemdsystemunitdir
			--disable-poman

			# build libraries
			--enable-libuuid
			--enable-libblkid
			--enable-libsmartcols
			--enable-libfdisk
			--enable-libmount

			# Support uuidd for non-native libuuid
			$(use_enable uuidd libuuid-force-uuidd)
		)
	fi

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"

	if multilib_is_native_abi && use python ; then
		python_foreach_impl python_configure
	fi
}

src_configure() {
	append-lfs-flags

	# Workaround for bug #961040 (gcc PR120006)
	if tc-is-gcc && [[ $(gcc-major-version) == 15 && $(gcc-minor-version) -lt 2 ]] ; then
		append-flags -fno-ipa-pta
	fi

	multilib-minimal_src_configure
}

python_compile() {
	pushd "${BUILD_DIR}" >/dev/null || die
	emake all
	popd >/dev/null || die
}

multilib_src_compile() {
	emake all

	if multilib_is_native_abi && use python ; then
		python_foreach_impl python_compile
	fi
}

python_test() {
	pushd "${BUILD_DIR}" >/dev/null || die
	emake check TS_OPTS="--parallel=$(makeopts_jobs) --nonroot"
	popd >/dev/null || die
}

multilib_src_test() {
	emake check TS_OPTS="--parallel=$(makeopts_jobs) --nonroot"
	if multilib_is_native_abi && use python ; then
		python_foreach_impl python_test
	fi
}

python_install() {
	pushd "${BUILD_DIR}" >/dev/null || die
	emake DESTDIR="${D}" install
	python_optimize
	popd >/dev/null || die
}

multilib_src_install() {
	if multilib_is_native_abi && use python ; then
		python_foreach_impl python_install
	fi

	# This needs to be called AFTER python_install call, bug #689190
	# XXX: -j1 as temporary workaround for bug #931301
	emake DESTDIR="${D}" install -j1
}

multilib_src_install_all() {
	dodoc AUTHORS NEWS README* Documentation/{TODO,*.txt,releases/*}

	dosym hexdump /usr/bin/hd
	newman - hd.1 <<< '.so man1/hexdump.1'

	# e2fsprogs-libs didn't install .la files, and .pc work fine
	find "${ED}" -name "*.la" -delete || die

	if use pam ; then
		# See https://github.com/util-linux/util-linux/blob/master/Documentation/PAM-configuration.txt
		newpamd "${FILESDIR}/runuser.pamd" runuser
		newpamd "${FILESDIR}/runuser-l.pamd" runuser-l

		newpamd "${FILESDIR}/su-l.pamd" su-l
	fi

	if use su && ! use suid ; then
		# Always force suid su, even when USE=-suid, as su is useless
		# for the overwhelming-majority case without suid.
		# Users who wish to truly have a no-suid su can strip it out
		# via e.g. Portage's suidctl or some other hook.
		# See bug #832092
		fperms u+s /bin/su
	fi

	if use uuidd; then
		newinitd "${FILESDIR}/uuidd.initd" uuidd
	fi

	# Note:
	# Bash completion for "runuser" command is provided by same file which
	# would also provide bash completion for "su" command. However, we don't
	# use "su" command from this package.
	# This triggers a known QA warning which we ignore for now to magically
	# keep bash completion for "su" command which shadow package does not
	# provide.

	local ver=$(tools/git-version-gen .tarballversion)
	local major=$(ver_cut 1 ${ver})
	local minor=$(ver_cut 2 ${ver})
	local release=$(ver_cut 3 ${ver})
	export QA_PKGCONFIG_VERSION="${major}.${minor}.${release:-0}"
}

pkg_postinst() {
	if ! use tty-helpers ; then
		elog "The mesg/wall/write tools have been disabled due to USE=-tty-helpers."
	fi

	if [[ -z ${REPLACING_VERSIONS} ]] ; then
		elog "The agetty util now clears the terminal by default. You"
		elog "might want to add --noclear to your /etc/inittab lines."
	fi

	if use systemd && use uuidd; then
		tmpfiles_process uuidd-tmpfiles.conf
	fi
}
