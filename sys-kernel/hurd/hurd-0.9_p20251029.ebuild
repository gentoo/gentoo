# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit crossdev flag-o-matic

DESCRIPTION="GNU Hurd is the GNU project's replacement for UNIX"
HOMEPAGE="https://www.gnu.org/software/hurd/hurd.html"

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://git.savannah.gnu.org/git/hurd/hurd.git"
	inherit autotools git-r3
elif [[ ${PV} == *_p* ]] ; then
	inherit autotools

	MY_PV=${PV%_p*}.git${PV#*_p}
	MY_P=${PN}_${MY_PV}

	# savannah doesn't allow snapshot downloads from cgit as of 2026-03,
	# but the Debian maintainer is also upstream, so just use theirs
	# instead.
	SRC_URI="mirror://debian/pool/main/${PN:0:1}/${PN}/${MY_P}.orig.tar.bz2"
	S="${WORKDIR}"/${MY_P/_/-}
else
	SRC_URI="mirror://gnu/${PN}/${P}.tar.bz2"
fi

LICENSE="GPL-2 BSD-2"
SLOT="0"
if is_crosspkg ; then
	IUSE="headers-only"
else
	IUSE="headers-only ncurses xkb"
fi
[[ ${PV} != 9999 ]] && KEYWORDS="~amd64 ~x86"

if is_crosspkg ; then
	BDEPEND="
		!headers-only? ( cross-${CTARGET}/mig )
	"
else
	# TODO: fix xkb automagic
	DEPEND="
		app-arch/bzip2:=[static-libs]
		dev-libs/libdaemon:=
		>=dev-libs/libgcrypt-1.8.0:=
		dev-util/mig
		sys-apps/util-linux[static-libs]
		x11-libs/libpciaccess[static-libs]
		virtual/libcrypt:=[static-libs]
		virtual/zlib:=[static-libs]
		ncurses? ( sys-libs/ncurses:= )
		xkb? ( x11-libs/libxkbcommon )
	"
	RDEPEND="${DEPEND}"
	BDEPEND="virtual/pkgconfig"
fi

PATCHES=(
	"${FILESDIR}"/${PN}-0.9_p20251029-glibc-2.43.patch
)

src_prepare() {
	default
	[[ ${PV} == 9999 || ${PV} == *_p* ]] && eautoreconf
}

src_configure() {
	if target_is_not_host ; then
		local sysroot=/usr/${CTARGET}
		export MIG="${CTARGET}-mig"
	fi

	local myeconfargs=(
		# XXX: --enable-static-progs seems to behave differently
		# to the default.
		--prefix="${EPREFIX}${sysroot}/usr"
		--datadir="${EPREFIX}${sysroot}/usr/share"
		--host=${CTARGET}
	)

	append-flags -Wl,--no-error-rwx-segments -Wl,--no-error-execstack -Wl,-z,notext

	if use headers-only ; then
		myeconfargs+=(
			ac_cv_func_file_exec_paths=no
			ac_cv_func_exec_exec_paths=no
			ac_cv_func__hurd_exec_paths=no
			ac_cv_func__hurd_libc_proc_init=no
			ac_cv_func_mach_port_set_ktype=no
			ac_cv_func_file_utimens=no

			--without-acpica
			--without-libcrypt
			--without-libbz2
			--without-libz
			--without-libtirpc
			--without-parted
			--without-rump
			--disable-ncursesw
		)
	else
		myeconfargs+=(
			# Builds everything twice and needs profiling libs
			--disable-profile

			# Unpackaged
			--without-acpica
			--without-rump

			# TODO (configure really wants parted)
			--without-parted
			# TODO (nfs)
			--without-libtirpc

			--with-libcrypt
			--with-libbz2
			--with-libz

			$(use_enable ncurses ncursesw)
		)
	fi

	econf "${myeconfargs[@]}"
}

src_compile() {
	use headers-only && return
	default
}

src_test() {
	use headers-only && return
	default
}

src_install() {
	emake DESTDIR="${D}" $(usex headers-only install-headers install) no_deps=t

	if target_is_not_host ; then
		# TODO: Is this needed?
		# On Hurd, gcc expects system headers to be in /include, not /usr/include
		dosym usr/include /usr/${CTARGET}/include

		# Avoid collisions for other Hurd targets
		# TODO: autoconf var?
		rm -rfv "${ED}"/usr/share/info || die
	fi
}
