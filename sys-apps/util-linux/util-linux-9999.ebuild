# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
TMPFILES_OPTIONAL=1

inherit flag-o-matic pam python-r1 meson-multilib tmpfiles toolchain-funcs

MY_PV="${PV/_/-}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="Various useful Linux utilities"
HOMEPAGE="https://www.kernel.org/pub/linux/utils/util-linux/ https://github.com/util-linux/util-linux"

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://git.kernel.org/pub/scm/utils/util-linux/util-linux.git"
	inherit git-r3
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

	# Workaround for bug #961040 (gcc PR120006)
	if tc-is-gcc && [[ $(gcc-major-version) == 15 && $(gcc-minor-version) -lt 2 ]] ; then
		append-flags -fno-ipa-pta
	fi

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
			lsns/filter
			findmnt/df-options
			findmnt/target
			findmnt/outputs
			findmnt/filterQ
			findmnt/filter
			misc/mountpoint
			lsblk/lsblk
			lslocks/lslocks
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

			# bashism
			kill/decode

			# Format changes?
			lslogins/checkuser
			misc/swaplabel
			misc/setarch
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
	fi
}

python_configure() {
	local emesonargs=(
		-Dauto_features=disabled
		-Dbuild-python=enabled
		-Dpython="${EPYTHON}"

		# XXX: The 'check' target doesn't get created with
		# -Dauto_features=disabled, but there's no Python-specific
		# tests anyway, so it's not a big deal.
		# See https://github.com/util-linux/util-linux/pull/3351 for
		# an incomplete fix.
		#$(meson_use test program-tests)

		-Dbuild-libblkid=enabled
		-Dbuild-libmount=enabled
	)

	mkdir "${BUILD_DIR}" || die
	pushd "${BUILD_DIR}" >/dev/null || die
	meson_src_configure
	popd >/dev/null || die
}

multilib_src_configure() {
	local emesonargs=(
		-Dbuild-python=disabled
		-Dfs-search-path-extra="${EPREFIX}/usr/sbin:${EPREFIX}/bin:${EPREFIX}/usr/bin"
		-Duse-tls=$(tc-has-tls && echo true || echo false)

		$(meson_use test program-tests)

		$(meson_native_use_feature audit)
		$(meson_native_use_feature readline)
		$(meson_native_use_feature slang)
		$(meson_native_use_feature magic)
		$(meson_feature unicode widechar)
		$(meson_native_use_feature uuidd build-uuidd)

		$(meson_feature nls)
		$(meson_feature selinux)
		$(meson_feature ncurses tinfo)
		-Ddefault_library=$(multilib_native_usex static-libs both shared)

		# TODO: Wire this up (bug #931118)
		-Deconf=disabled

		# TODO: Wire this up (bug #931297)
		-Dbuild-liblastlog2=disabled
		-Dbuild-pam-lastlog2=disabled

		# Provided by sys-apps/shadow
		-Dbuild-chfn-chsh=disabled
		-Dbuild-login=disabled
		-Dbuild-newgrp=disabled
		-Dbuild-nologin=disabled
		-Dbuild-vipw=disabled

		-Dbuild-pylibmount=disabled
		-Dbuild-raw=disabled

		$(meson_native_enabled build-agetty)
		$(meson_native_enabled build-bash-completion)
		$(meson_native_enabled build-line)
		$(meson_native_enabled build-partx)
		$(meson_native_enabled build-rename)
		$(meson_native_enabled build-rfkill)
		$(meson_native_enabled build-schedutils)

		$(meson_native_use_feature caps build-setpriv)
		$(meson_native_use_feature cramfs build-cramfs)
		$(meson_native_use_feature fdformat build-fdformat)
		$(meson_native_use_feature hardlink build-hardlink)
		$(meson_native_use_feature kill build-kill)
		$(meson_native_use_feature logger build-logger)
		$(meson_native_use_feature ncurses build-pg)
		$(meson_native_use_feature su build-su)
		$(meson_native_use_feature tty-helpers build-mesg)
		$(meson_native_use_feature tty-helpers build-wall)
		$(meson_native_use_feature tty-helpers build-write)
		$(meson_native_use_feature cryptsetup)

		# Libraries
		-Dbuild-libuuid=enabled
		-Dbuild-libblkid=enabled
		-Dbuild-libsmartcols=enabled
		-Dbuild-libfdisk=enabled
		-Dbuild-libmount=enabled

		# TODO: Support uuidd for non-native libuuid (do we want this still?)
		#$(use_enable uuidd libuuid-force-uuidd)
	)

	# TODO: udev (which seems to be controlled by just the systemd option right now?)
	if use build ; then
		emesonargs+=(
			-Dsystemd=disabled
		)
	else
		emesonargs+=(
			$(meson_native_use_feature systemd)
		)
	fi

	local native_file="${T}"/meson.${CHOST}.${ABI}.ini.local
	cat >> ${native_file} <<-EOF || die
	[binaries]
	asciidoctor='asciidoctor-falseified'
	EOF
	# TODO: Verify this does the right thing for releases (may need to
	# manually install).
	if [[ ${PV} != *9999 ]] ; then
		# Upstream is shipping pre-generated man-pages for releases
		emesonargs+=(
			--native-file "${native_file}"
		)
	fi

	# TODO: check pam automagic (bug #485486, bug #545042)
	#export ac_cv_header_security_pam_misc_h=$(multilib_native_usex pam)
	#export ac_cv_header_security_pam_appl_h=$(multilib_native_usex pam)
	#
	# TODO: check librtas automagic to avoid automagic dependency on ppc*
	#export ac_cv_lib_rtas_rtas_get_sysparm=$(usex rtas)

	meson_src_configure

	if multilib_is_native_abi && use python ; then
		python_foreach_impl python_configure
	fi
}

python_compile() {
	pushd "${BUILD_DIR}" >/dev/null || die
	meson_src_compile
	popd >/dev/null || die
}

multilib_src_compile() {
	meson_src_compile

	if multilib_is_native_abi && use python ; then
		python_foreach_impl python_compile
	fi
}

python_test() {
	pushd "${BUILD_DIR}" >/dev/null || die
	# XXX: See python_configure
	#eninja check
	popd >/dev/null || die
}

multilib_src_test() {
	eninja check

	if multilib_is_native_abi && use python ; then
		python_foreach_impl python_test
	fi
}

python_install() {
	pushd "${BUILD_DIR}" >/dev/null || die
	meson_src_install
	python_optimize
	popd >/dev/null || die
}

multilib_src_install() {
	if multilib_is_native_abi && use python ; then
		python_foreach_impl python_install
	fi

	meson_src_install
}

multilib_src_install_all() {
	dodoc AUTHORS NEWS README* Documentation/{TODO,*.txt,releases/*}

	dosym hexdump /usr/bin/hd
	newman - hd.1 <<< '.so man1/hexdump.1'

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
