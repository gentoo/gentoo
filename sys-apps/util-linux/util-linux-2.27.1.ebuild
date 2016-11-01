# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PYTHON_COMPAT=( python2_7 python3_4 )

inherit eutils toolchain-funcs libtool flag-o-matic bash-completion-r1 \
	python-single-r1 multilib-minimal systemd

MY_PV=${PV/_/-}
MY_P=${PN}-${MY_PV}

if [[ ${PV} == 9999 ]] ; then
	inherit git-2 autotools
	EGIT_REPO_URI="git://git.kernel.org/pub/scm/utils/util-linux/util-linux.git"
else
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~arm-linux ~x86-linux"
	SRC_URI="mirror://kernel/linux/utils/util-linux/v${PV:0:4}/${MY_P}.tar.xz"
fi

DESCRIPTION="Various useful Linux utilities"
HOMEPAGE="https://www.kernel.org/pub/linux/utils/util-linux/"

LICENSE="GPL-2 LGPL-2.1 BSD-4 MIT public-domain"
SLOT="0"
IUSE="build caps +cramfs fdformat kill ncurses nls pam python +readline selinux slang static-libs +suid systemd test tty-helpers udev unicode"

RDEPEND="caps? ( sys-libs/libcap-ng )
	cramfs? ( sys-libs/zlib )
	ncurses? ( >=sys-libs/ncurses-5.2-r2:0=[unicode?] )
	pam? ( sys-libs/pam )
	python? ( ${PYTHON_DEPS} )
	readline? ( sys-libs/readline:0= )
	selinux? ( >=sys-libs/libselinux-2.2.2-r4[${MULTILIB_USEDEP}] )
	slang? ( sys-libs/slang )
	!build? ( systemd? ( sys-apps/systemd ) )
	udev? ( virtual/libudev:= )
	abi_x86_32? (
		!<=app-emulation/emul-linux-x86-baselibs-20150406-r2
		!app-emulation/emul-linux-x86-baselibs[-abi_x86_32]
	)"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
	test? ( sys-devel/bc )
	virtual/os-headers"
RDEPEND+="
	kill? (
		!sys-apps/coreutils[kill]
		!sys-process/procps[kill]
	)
	!sys-process/schedutils
	!sys-apps/setarch
	!<sys-apps/sysvinit-2.88-r7
	!sys-block/eject
	!<sys-libs/e2fsprogs-libs-1.41.8
	!<sys-fs/e2fsprogs-1.41.8
	!<app-shells/bash-completion-1.3-r2"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	if [[ ${PV} == 9999 ]] ; then
		po/update-potfiles
		eautoreconf
	fi
	epatch "${FILESDIR}"/${P}-sysmacros.patch
	elibtoolize
}

lfs_fallocate_test() {
	# Make sure we can use fallocate with LFS #300307
	cat <<-EOF > "${T}"/fallocate.${ABI}.c
		#define _GNU_SOURCE
		#include <fcntl.h>
		main() { return fallocate(0, 0, 0, 0); }
	EOF
	append-lfs-flags
	$(tc-getCC) ${CFLAGS} ${CPPFLAGS} ${LDFLAGS} "${T}"/fallocate.${ABI}.c -o /dev/null >/dev/null 2>&1 \
		|| export ac_cv_func_fallocate=no
	rm -f "${T}"/fallocate.${ABI}.c
}

multilib_src_configure() {
	lfs_fallocate_test
	# The scanf test in a run-time test which fails while cross-compiling.
	# Blindly assume a POSIX setup since we require libmount, and libmount
	# itself fails when the scanf test fails. #531856
	tc-is-cross-compiler && export scanf_cv_alloc_modifier=ms
	export ac_cv_header_security_pam_misc_h=$(multilib_native_usex pam) #485486
	export ac_cv_header_security_pam_appl_h=$(multilib_native_usex pam) #545042
	ECONF_SOURCE=${S} \
	econf \
		--enable-fs-paths-extra="${EPREFIX}/usr/sbin:${EPREFIX}/bin:${EPREFIX}/usr/bin" \
		--docdir='${datarootdir}'/doc/${PF} \
		$(multilib_native_use_enable nls) \
		--enable-agetty \
		--with-bashcompletiondir="$(get_bashcompdir)" \
		--enable-bash-completion \
		$(multilib_native_use_enable caps setpriv) \
		--disable-chfn-chsh \
		$(multilib_native_use_enable cramfs) \
		$(multilib_native_use_enable fdformat) \
		--with-ncurses=$(multilib_native_usex ncurses $(usex unicode auto yes) no) \
		$(use_enable kill) \
		--disable-login \
		$(multilib_native_use_enable tty-helpers mesg) \
		--disable-nologin \
		--enable-partx \
		$(multilib_native_use_with python) \
		--enable-raw \
		$(multilib_native_use_with readline) \
		--enable-rename \
		--disable-reset \
		--enable-schedutils \
		--disable-su \
		$(multilib_native_use_enable tty-helpers wall) \
		$(multilib_native_use_enable tty-helpers write) \
		$(multilib_native_use_enable suid makeinstall-chown) \
		$(multilib_native_use_enable suid makeinstall-setuid) \
		$(use_with selinux) \
		$(multilib_native_use_with slang) \
		$(use_enable static-libs static) \
		$(multilib_native_use_with systemd) \
		--with-systemdsystemunitdir=$(multilib_native_usex systemd "$(systemd_get_unitdir)" "no") \
		$(multilib_native_use_with udev) \
		$(tc-has-tls || echo --disable-tls)
}

multilib_src_compile() {
	if multilib_is_native_abi; then
		default
	else
		# build libraries only
		emake -f Makefile -f - mylibs \
			<<< 'mylibs: $(usrlib_exec_LTLIBRARIES) $(pkgconfig_DATA)'
	fi
}

multilib_src_test() {
	multilib_is_native_abi && emake check
}

multilib_src_install() {
	if multilib_is_native_abi; then
		default
	else
		emake DESTDIR="${D}" install-usrlib_execLTLIBRARIES \
			install-pkgconfigDATA install-uuidincHEADERS \
			install-nodist_blkidincHEADERS install-nodist_mountincHEADERS \
			install-nodist_smartcolsincHEADERS install-nodist_fdiskincHEADERS
	fi

	if multilib_is_native_abi; then
		# need the libs in /
		gen_usr_ldscript -a blkid mount smartcols uuid

		use python && python_optimize
	fi
}

multilib_src_install_all() {
	dodoc AUTHORS NEWS README* Documentation/{TODO,*.txt,releases/*}

	# e2fsprogs-libs didnt install .la files, and .pc work fine
	prune_libtool_files
}

pkg_postinst() {
	if ! use tty-helpers; then
		elog "The mesg/wall/write tools have been disabled due to USE=-tty-helpers."
	fi

	if [[ -z ${REPLACING_VERSIONS} ]]; then
		elog "The agetty util now clears the terminal by default. You"
		elog "might want to add --noclear to your /etc/inittab lines."
	fi
}
