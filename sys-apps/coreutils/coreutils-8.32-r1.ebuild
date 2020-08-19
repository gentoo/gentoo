# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit eutils flag-o-matic python-any-r1 toolchain-funcs

PATCH="${PN}-8.30-patches-01"
DESCRIPTION="Standard GNU utilities (chmod, cp, dd, ls, sort, tr, head, wc, who,...)"
HOMEPAGE="https://www.gnu.org/software/coreutils/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.xz
	!vanilla? (
		mirror://gentoo/${PATCH}.tar.xz
		https://dev.gentoo.org/~polynomial-c/dist/${PATCH}.tar.xz
	)
"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 sparc ~x86 ~x86-linux"
IUSE="acl caps gmp hostname kill multicall nls selinux +split-usr static test vanilla xattr"
RESTRICT="!test? ( test )"

LIB_DEPEND="acl? ( sys-apps/acl[static-libs] )
	caps? ( sys-libs/libcap )
	gmp? ( dev-libs/gmp:=[static-libs] )
	xattr? ( sys-apps/attr[static-libs] )"
RDEPEND="!static? ( ${LIB_DEPEND//\[static-libs]} )
	selinux? ( sys-libs/libselinux )
	nls? ( virtual/libintl )"
DEPEND="
	${RDEPEND}
	static? ( ${LIB_DEPEND} )
"
BDEPEND="
	app-arch/xz-utils
	test? (
		dev-lang/perl
		dev-perl/Expect
		dev-util/strace
		${PYTHON_DEPS}
	)
"
RDEPEND+="
	hostname? ( !sys-apps/net-tools[hostname] )
	kill? (
		!sys-apps/util-linux[kill]
		!sys-process/procps[kill]
	)
	!app-misc/realpath
	!<sys-apps/util-linux-2.13
	!<sys-apps/sandbox-2.10-r4
	!sys-apps/stat
	!net-mail/base64
	!sys-apps/mktemp
	!<app-forensics/tct-1.18-r1
	!<net-fs/netatalk-2.0.3-r4"

pkg_setup() {
	if use test ; then
		python-any-r1_pkg_setup
	fi
}

src_prepare() {
	local PATCHES=(
		"${FILESDIR}"/coreutils-8.32-ls-restore-8.31-behavior.patch
	)

	if ! use vanilla ; then
		PATCHES+=( "${WORKDIR}"/patch )
		PATCHES+=( "${FILESDIR}"/${PN}-8.32-sandbox-env-test.patch )
	fi

	default

	# Since we've patched many .c files, the make process will try to
	# re-build the manpages by running `./bin --help`.  When doing a
	# cross-compile, we can't do that since 'bin' isn't a native bin.
	# Also, it's not like we changed the usage on any of these things,
	# so let's just update the timestamps and skip the help2man step.
	set -- man/*.x
	touch ${@/%x/1}

	# Avoid perl dep for compiled in dircolors default #348642
	if ! has_version dev-lang/perl ; then
		touch src/dircolors.h
		touch ${@/%x/1}
	fi
}

src_configure() {
	local myconf=(
		--with-packager="Gentoo"
		--with-packager-version="${PVR} (p${PATCH_VER:-0})"
		--with-packager-bug-reports="https://bugs.gentoo.org/"
		--enable-install-program="arch,$(usev hostname),$(usev kill)"
		--enable-no-install-program="groups,$(usev !hostname),$(usev !kill),su,uptime"
		--enable-largefile
		$(usex caps '' --disable-libcap)
		$(use_enable nls)
		$(use_enable acl)
		$(use_enable multicall single-binary)
		$(use_enable xattr)
		$(use_with gmp)
	)
	if tc-is-cross-compiler && [[ ${CHOST} == *linux* ]] ; then
		export fu_cv_sys_stat_statfs2_bsize=yes #311569
		export gl_cv_func_realpath_works=yes #416629
	fi

	export gl_cv_func_mknod_works=yes #409919
	use static && append-ldflags -static && sed -i '/elf_sys=yes/s:yes:no:' configure #321821
	use selinux || export ac_cv_{header_selinux_{context,flash,selinux}_h,search_setfilecon}=no #301782
	# kill/uptime - procps
	# groups/su   - shadow
	# hostname    - net-tools
	econf "${myconf[@]}"
}

src_test() {
	# Known to fail with FEATURES=usersandbox (bug #439574):
	#   -  tests/du/long-from-unreadable.sh} (bug #413621)
	#   -  tests/rm/deep-2.sh (bug #413621)
	#   -  tests/dd/no-allocate.sh (bug #629660)
	if has usersandbox ${FEATURES} ; then
		ewarn "You are emerging ${P} with 'usersandbox' enabled." \
			"Expect some test failures or emerge with 'FEATURES=-usersandbox'!"
	fi

	# Non-root tests will fail if the full path isn't
	# accessible to non-root users
	chmod -R go-w "${WORKDIR}"
	chmod a+rx "${WORKDIR}"

	# coreutils tests like to do `mount` and such with temp dirs
	# so make sure /etc/mtab is writable #265725
	# make sure /dev/loop* can be mounted #269758
	mkdir -p "${T}"/mount-wrappers || die
	mkwrap() {
		local w ww
		for w in "${@}" ; do
			ww="${T}/mount-wrappers/${w}"
			cat <<-EOF > "${ww}"
				#!${EPREFIX}/bin/sh
				exec env SANDBOX_WRITE="\${SANDBOX_WRITE}:/etc/mtab:/dev/loop" $(type -P ${w}) "\$@"
			EOF
			chmod a+rx "${ww}"
		done
	}
	mkwrap mount umount

	addwrite /dev/full
	#export RUN_EXPENSIVE_TESTS="yes"
	#export FETISH_GROUPS="portage wheel"
	env PATH="${T}/mount-wrappers:${PATH}" \
	emake -j1 -k check
}

src_install() {
	default

	insinto /etc
	newins src/dircolors.hin DIR_COLORS

	if use split-usr ; then
		cd "${ED}"/usr/bin || die
		dodir /bin
		# move critical binaries into /bin (required by FHS)
		local fhs="cat chgrp chmod chown cp date dd df echo false ln ls
		           mkdir mknod mv pwd rm rmdir stty sync true uname"
		mv ${fhs} ../../bin/ || die "could not move fhs bins"
		if use hostname; then
			mv hostname ../../bin/ || die
		fi
		if use kill; then
			mv kill ../../bin/ || die
		fi
		# move critical binaries into /bin (common scripts)
		# Why are these required for booting?
		local com="basename chroot cut dir dirname du env expr head mkfifo
		           mktemp readlink seq sleep sort tail touch tr tty vdir wc yes"
		mv ${com} ../../bin/ || die "could not move common bins"
		# create a symlink for uname in /usr/bin/ since autotools require it
		# Other than uname, we need to figure out why we are
		# creating symlinks for these in /usr/bin instead of leaving
		# the files there in the first place.
		local x
		for x in ${com} uname ; do
			dosym ../../bin/${x} /usr/bin/${x}
		done
	fi
}

pkg_postinst() {
	ewarn "Make sure you run 'hash -r' in your active shells."
	ewarn "You should also re-source your shell settings for LS_COLORS"
	ewarn "  changes, such as: source /etc/profile"
}
