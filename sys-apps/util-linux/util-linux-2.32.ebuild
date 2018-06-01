# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )

inherit toolchain-funcs libtool flag-o-matic bash-completion-r1 \
	pam python-single-r1 multilib-minimal multiprocessing systemd

MY_PV="${PV/_/-}"
MY_P="${PN}-${MY_PV}"

if [[ ${PV} == 9999 ]] ; then
	inherit git-r3 autotools
	EGIT_REPO_URI="https://git.kernel.org/pub/scm/utils/util-linux/util-linux.git"
else
	[[ "${PV}" = *_rc* ]] || \
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~arm-linux ~x86-linux"
	SRC_URI="mirror://kernel/linux/utils/util-linux/v${PV:0:4}/${MY_P}.tar.xz"
fi

DESCRIPTION="Various useful Linux utilities"
HOMEPAGE="https://www.kernel.org/pub/linux/utils/util-linux/"

LICENSE="GPL-2 LGPL-2.1 BSD-4 MIT public-domain"
SLOT="0"
IUSE="build caps +cramfs fdformat kill ncurses nls pam python +readline selinux slang static-libs +suid systemd test tty-helpers udev unicode"

# Most lib deps here are related to programs rather than our libs,
# so we rarely need to specify ${MULTILIB_USEDEP}.
RDEPEND="caps? ( sys-libs/libcap-ng )
	cramfs? ( sys-libs/zlib:= )
	ncurses? ( >=sys-libs/ncurses-5.2-r2:0=[unicode?] )
	pam? ( sys-libs/pam )
	python? ( ${PYTHON_DEPS} )
	readline? ( sys-libs/readline:0= )
	selinux? ( >=sys-libs/libselinux-2.2.2-r4[${MULTILIB_USEDEP}] )
	slang? ( sys-libs/slang )
	!build? ( systemd? ( sys-apps/systemd ) )
	udev? ( virtual/libudev:= )"
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
	!net-wireless/rfkill
	!sys-process/schedutils
	!sys-apps/setarch
	!<sys-apps/sysvinit-2.88-r7
	!<sys-libs/e2fsprogs-libs-1.41.8
	!<sys-fs/e2fsprogs-1.41.8
	!<app-shells/bash-completion-2.7-r1
	!<sys-apps/s390-tools-1.36.1-r1"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	default

	# Prevent uuidd test failure due to socket path limit. #593304
	sed -i \
		-e "s|UUIDD_SOCKET=\"\$(mktemp -u \"\${TS_OUTDIR}/uuiddXXXXXXXXXXXXX\")\"|UUIDD_SOCKET=\"\$(mktemp -u \"${T}/uuiddXXXXXXXXXXXXX.sock\")\"|g" \
		tests/ts/uuid/uuidd || die "Failed to fix uuidd test"

	if [[ ${PV} == 9999 ]] ; then
		po/update-potfiles
		eautoreconf
	fi

	# Undo bad ncurses handling by upstream. #601530
	sed -i -E \
		-e '/NCURSES_/s:(ncursesw?)[56]-config:$PKG_CONFIG \1:' \
		-e 's:(ncursesw?)[56]-config --version:$PKG_CONFIG --exists --print-errors \1:' \
		configure || die

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

	local myeconfargs=(
		--disable-chfn-chsh
		--disable-login
		--disable-nologin
		--disable-su
		--docdir='${datarootdir}'/doc/${PF}
		--enable-agetty
		--enable-bash-completion
		--enable-fs-paths-extra="${EPREFIX}/usr/sbin:${EPREFIX}/bin:${EPREFIX}/usr/bin"
		--enable-line
		--enable-partx
		--enable-raw
		--enable-rename
		--enable-rfkill
		--enable-schedutils
		--with-bashcompletiondir="$(get_bashcompdir)"
		--with-systemdsystemunitdir=$(multilib_native_usex systemd "$(systemd_get_systemunitdir)" "no")
		$(multilib_native_use_enable caps setpriv)
		$(multilib_native_use_enable cramfs)
		$(multilib_native_use_enable fdformat)
		$(multilib_native_use_enable nls)
		$(multilib_native_use_enable suid makeinstall-chown)
		$(multilib_native_use_enable suid makeinstall-setuid)
		$(multilib_native_use_enable tty-helpers mesg)
		$(multilib_native_use_enable tty-helpers wall)
		$(multilib_native_use_enable tty-helpers write)
		$(multilib_native_use_with python)
		$(multilib_native_use_with readline)
		$(multilib_native_use_with slang)
		$(multilib_native_use_with systemd)
		$(multilib_native_use_with udev)
		$(multilib_native_usex ncurses "$(use_with unicode ncursesw)" '--without-ncursesw')
		$(multilib_native_usex ncurses "$(use_with !unicode ncurses)" '--without-ncurses')
		$(tc-has-tls || echo --disable-tls)
		$(use_enable unicode widechar)
		$(use_enable kill)
		$(use_enable static-libs static)
		$(use_with selinux)
		$(usex ncurses '' '--without-tinfo')
	)
	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
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
	multilib_is_native_abi && emake check TS_OPTS="--parallel=$(makeopts_jobs) --nonroot"
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
	find "${ED}" -name "*.la" -delete || die

	if use pam; then
		newpamd "${FILESDIR}/runuser.pamd" runuser
		newpamd "${FILESDIR}/runuser-l.pamd" runuser-l
	fi
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
