# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Try to keep an eye on Fedora's packaging: https://src.fedoraproject.org/rpms/coreutils
# The upstream coreutils maintainers also maintain the package in Fedora and may
# backport fixes which we want to pick up.
#
# Also recommend subscribing to the coreutils and bug-coreutils MLs.

PYTHON_COMPAT=( python3_{9..11} )
VERIFY_SIG_OPENPGP_KEY_PATH="${BROOT}"/usr/share/openpgp-keys/coreutils.asc
inherit flag-o-matic python-any-r1 toolchain-funcs verify-sig

MY_PATCH="${PN}-9.0_p20220409-patches-01"
DESCRIPTION="Standard GNU utilities (chmod, cp, dd, ls, sort, tr, head, wc, who,...)"
HOMEPAGE="https://www.gnu.org/software/coreutils/"

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://git.savannah.gnu.org/git/coreutils.git"
	inherit git-r3
elif [[ ${PV} == *_p* ]] ; then
	# Note: could put this in devspace, but if it's gone, we don't want
	# it in tree anyway. It's just for testing.
	MY_SNAPSHOT="$(ver_cut 1-2).18-ffd62"
	SRC_URI="https://www.pixelbeat.org/cu/coreutils-${MY_SNAPSHOT}.tar.xz -> ${P}.tar.xz"
	SRC_URI+=" verify-sig? ( https://www.pixelbeat.org/cu/coreutils-${MY_SNAPSHOT}.tar.xz.sig -> ${P}.tar.xz.sig )"
	S="${WORKDIR}"/${PN}-${MY_SNAPSHOT}
else
	SRC_URI="
		mirror://gnu/${PN}/${P}.tar.xz
		verify-sig? ( mirror://gnu/${PN}/${P}.tar.xz.sig )
	"

	KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x86-linux"
fi

SRC_URI+=" !vanilla? ( https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${MY_PATCH}.tar.xz )"

LICENSE="GPL-3+"
SLOT="0"
IUSE="acl caps gmp hostname kill multicall nls +openssl selinux +split-usr static test vanilla xattr"
RESTRICT="!test? ( test )"

LIB_DEPEND="
	acl? ( sys-apps/acl[static-libs] )
	caps? ( sys-libs/libcap )
	gmp? ( dev-libs/gmp:=[static-libs] )
	openssl? ( dev-libs/openssl:=[static-libs] )
	xattr? ( sys-apps/attr[static-libs] )
"
RDEPEND="
	!static? ( ${LIB_DEPEND//\[static-libs]} )
	selinux? ( sys-libs/libselinux )
	nls? ( virtual/libintl )
"
DEPEND="
	${RDEPEND}
	static? ( ${LIB_DEPEND} )
"
BDEPEND="
	app-arch/xz-utils
	dev-lang/perl
	test? (
		dev-lang/perl
		dev-perl/Expect
		dev-util/strace
		${PYTHON_DEPS}
	)
	verify-sig? ( sec-keys/openpgp-keys-coreutils )
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

src_unpack() {
	if [[ ${PV} == 9999 ]] ; then
		git-r3_src_unpack

		cd "${S}" || die
		./bootstrap || die

		sed -i -e "s:submodule-checks ?= no-submodule-changes public-submodule-commit:submodule-checks ?= no-submodule-changes:" gnulib/top/maint.mk || die
	elif use verify-sig ; then
		# Needed for downloaded patch (which is unsigned, which is fine)
		verify-sig_verify_detached "${DISTDIR}"/${P}.tar.xz{,.sig}
	fi

	default
}

src_prepare() {
	local PATCHES=(
		# Upstream patches
		"${FILESDIR}"/${P}-cp-parents-preserve-permissions.patch
		"${FILESDIR}"/${P}-old-kernel-copy_file_range.patch
	)

	if ! use vanilla && [[ -d "${WORKDIR}"/patch ]] ; then
		PATCHES+=( "${WORKDIR}"/patch )
	fi

	default

	# Just for ${P}-old-kernel-copy_file_range.patch
	touch aclocal.m4 configure.ac Makefile.in gnulib-tests/Makefile.in configure || die

	# Since we've patched many .c files, the make process will try to
	# re-build the manpages by running `./bin --help`.  When doing a
	# cross-compile, we can't do that since 'bin' isn't a native bin.
	#
	# Also, it's not like we changed the usage on any of these things,
	# so let's just update the timestamps and skip the help2man step.
	set -- man/*.x
	touch ${@/%x/1} || die

	# Avoid perl dep for compiled in dircolors default (bug #348642)
	if ! has_version dev-lang/perl ; then
		touch src/dircolors.h || die
		touch ${@/%x/1} || die
	fi
}

src_configure() {
	# On alpha at least, gnulib (as of 9.3) can't seem to figure out we need
	# _F_O_B=64: https://debbugs.gnu.org/64123
	append-lfs-flags

	local myconf=(
		--with-packager="Gentoo"
		--with-packager-version="${PVR} (p${PATCH_VER:-0})"
		--with-packager-bug-reports="https://bugs.gentoo.org/"
		# kill/uptime - procps
		# groups/su   - shadow
		# hostname    - net-tools
		--enable-install-program="arch,$(usev hostname),$(usev kill)"
		--enable-no-install-program="groups,$(usev !hostname),$(usev !kill),su,uptime"
		$(usex caps '' --disable-libcap)
		$(use_enable nls)
		$(use_enable acl)
		$(use_enable multicall single-binary)
		$(use_enable xattr)
		$(use_with gmp libgmp)
		$(use_with openssl)
	)

	if use gmp ; then
		myconf+=( --with-libgmp-prefix="${ESYSROOT}"/usr )
	fi

	if tc-is-cross-compiler && [[ ${CHOST} == *linux* ]] ; then
		# bug #311569
		export fu_cv_sys_stat_statfs2_bsize=yes
		# bug #416629
		export gl_cv_func_realpath_works=yes
	fi

	# bug #409919
	export gl_cv_func_mknod_works=yes

	if use static ; then
		append-ldflags -static
		# bug #321821
		sed -i '/elf_sys=yes/s:yes:no:' configure || die
	fi

	if ! use selinux ; then
		# bug #301782
		export ac_cv_{header_selinux_{context,flash,selinux}_h,search_setfilecon}=no
	fi

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
	chmod -R go-w "${WORKDIR}" || die
	chmod a+rx "${WORKDIR}" || die

	# coreutils tests like to do `mount` and such with temp dirs,
	# so make sure:
	# - /etc/mtab is writable (bug #265725)
	# - /dev/loop* can be mounted (bug #269758)
	mkdir -p "${T}"/mount-wrappers || die
	mkwrap() {
		local w ww
		for w in "${@}" ; do
			ww="${T}/mount-wrappers/${w}"
			cat <<-EOF > "${ww}"
				#!${EPREFIX}/bin/sh
				exec env SANDBOX_WRITE="\${SANDBOX_WRITE}:/etc/mtab:/dev/loop" $(type -P ${w}) "\$@"
			EOF
			chmod a+rx "${ww}" || die
		done
	}
	mkwrap mount umount

	addwrite /dev/full
	#export RUN_EXPENSIVE_TESTS="yes"
	#export COREUTILS_GROUPS="portage wheel"
	env PATH="${T}/mount-wrappers:${PATH}" gl_public_submodule_commit= \
		emake -k check VERBOSE=yes
}

src_install() {
	default

	insinto /etc
	newins src/dircolors.hin DIR_COLORS

	if use split-usr ; then
		cd "${ED}"/usr/bin || die
		dodir /bin

		# Move critical binaries into /bin (required by FHS)
		local fhs="cat chgrp chmod chown cp date dd df echo false ln ls
		           mkdir mknod mv pwd rm rmdir stty sync true uname"
		mv ${fhs} ../../bin/ || die "Could not move FHS bins!"

		if use hostname ; then
			mv hostname ../../bin/ || die
		fi

		if use kill ; then
			mv kill ../../bin/ || die
		fi

		# Move critical binaries into /bin (common scripts)
		# (Why are these required for booting?)
		local com="basename chroot cut dir dirname du env expr head mkfifo
		           mktemp readlink seq sleep sort tail touch tr tty vdir wc yes"
		mv ${com} ../../bin/ || die "Could not move common bins!"

		# Create a symlink for uname in /usr/bin/ since autotools require it.
		# (Other than uname, we need to figure out why we are
		# creating symlinks for these in /usr/bin instead of leaving
		# the files there in the first place...)
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
