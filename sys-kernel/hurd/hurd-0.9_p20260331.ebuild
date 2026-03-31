# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit crossdev multilib flag-o-matic

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
	#SRC_URI="mirror://debian/pool/main/${PN:0:1}/${PN}/${MY_P}.orig.tar.bz2"
	#S="${WORKDIR}"/${MY_P/_/-}

	# Debian only make full snapshots every so often, but apply other
	# commits as backports. This is a bit awkward for us to follow, so
	# roll our own snapshots:
	# $ git archive --format=tar --prefix=hurd/ HEAD | xz > hurd-0.9_p20260331.tar.xz
	SRC_URI="https://distfiles.gentoo.org/pub/proj/hurd/snapshots/hurd/${P}.tar.xz"
	S="${WORKDIR}"/${PN}
else
	SRC_URI="mirror://gnu/${PN}/${P}.tar.bz2"
fi

LICENSE="GPL-2 BSD-2"
SLOT="0"
if is_crosspkg ; then
	IUSE="custom-cflags headers-only"
else
	IUSE="custom-cflags headers-only ncurses rumpkernel xkb"
fi
[[ ${PV} != 9999 ]] && KEYWORDS="~amd64 ~x86"

if is_crosspkg ; then
	BDEPEND="
		!headers-only? ( cross-${CTARGET}/mig )
	"
else
	DEPEND="
		app-arch/bzip2:=[static-libs]
		dev-libs/libdaemon:=
		>=dev-libs/libgcrypt-1.8.0:=
		dev-util/mig
		sys-apps/util-linux[static-libs]
		sys-block/parted[static-libs]
		sys-power/libacpica
		x11-libs/libpciaccess[static-libs]
		virtual/libcrypt:=[static-libs]
		virtual/zlib:=[static-libs]
		ncurses? ( sys-libs/ncurses:= )
		rumpkernel? ( sys-kernel/rumpkernel )
		xkb? ( x11-libs/libxkbcommon )
	"
	RDEPEND="${DEPEND}"
	BDEPEND="virtual/pkgconfig"
fi

PATCHES=(
	"${FILESDIR}"/${PN}-0.9_p20251029-rump-link.patch
	"${FILESDIR}"/${PN}-0.9_p20251029-openrc-init-no-a.patch
	"${FILESDIR}"/${PN}-0.9_p20251029-libports-iterate-refcount.patch
)

src_prepare() {
	default
	[[ ${PV} == 9999 || ${PV} == *_p* ]] && eautoreconf
}

src_configure() {
	if target_is_not_host ; then
		local sysroot=/usr/${CTARGET}
		export MIG="${CTARGET}-mig"

		# Ensure we get compatible libdir
		unset DEFAULT_ABI MULTILIB_ABIS
		multilib_env
		ABI=${DEFAULT_ABI}
	fi

	local myeconfargs=(
		# XXX: --enable-static-progs seems to behave differently
		# to the default.
		--prefix="${EPREFIX}${sysroot}/usr"
		--datadir="${EPREFIX}${sysroot}/usr/share"
		--host=${CTARGET}

		# Builds everything twice and needs profiling libs
		--disable-profile
	)

	if ! use custom-cflags ; then
		strip-flags
		filter-lto
		# Hangs on boot without this
		append-flags -U_FORTIFY_SOURCE
	fi

	append-flags -Wl,--no-error-rwx-segments -Wl,--no-error-execstack -Wl,-z,notext

	# For cross-*, we always want a minimal build even with USE=-headers-only,
	# as we will need libshouldbeinlibc.
	if use headers-only || is_crosspkg ; then
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
			--without-libdaemon
			--without-libz
			--without-libtirpc
			--without-parted
			--without-rump
			--disable-ncursesw
		)

		cat <<-EOF >> config.make.in || die "Failed to amend config.make.in"
		HAVE_LIBGCRYPT = no
		HAVE_LIBPCIACCESS = no
		HAVE_XKBCOMMON = no
		EOF
	else
		myeconfargs+=(
			# TODO (nfs)
			--without-libtirpc

			--with-acpica
			--with-libcrypt
			--with-libbz2
			--with-libz
			# configure really wants parted
			# it's also essential for rumpdisk:
			# https://lists.gnu.org/r/bug-hurd/2023-05/msg00405.html
			--with-parted

			$(use_enable ncurses ncursesw)
			$(use_with rumpkernel rump)
		)

		cat <<-EOF >> config.make.in || die "Failed to amend config.make.in"
		HAVE_XKBCOMMON = $(usex xkb)
		EOF
	fi

	econf "${myeconfargs[@]}"
}

src_compile() {
	if use headers-only ; then
		return
	elif is_crosspkg ; then
		# For the crossdev-built Hurd, we need to build enough s.t.
		# for the sysroot cross-built Hurd, its deps can be compiled
		# first (e.g. sys-block/parted, sys-kernel/rumpkernel).
		emake \
			lib-subdirs="libshouldbeinlibc libihash libstore libirqhelp" \
			prog-subdirs= \
			other-subdirs=
	else
		default
	fi
}

src_test() {
	use headers-only && return
	default
}

src_install() {
	if use headers-only ; then
		emake DESTDIR="${D}" install-headers no_deps=t
	elif is_crosspkg ; then
		emake DESTDIR="${D}" install-headers no_deps=t
		emake DESTDIR="${D}" install \
			lib-subdirs="libshouldbeinlibc libihash libstore libirqhelp" \
			prog-subdirs= \
			other-subdirs= \
			no_deps=t
	else
		emake DESTDIR="${D}" install
	fi

	if target_is_not_host ; then
		# TODO: Is this needed?
		# On Hurd, gcc expects system headers to be in /include, not /usr/include
		dosym usr/include /usr/${CTARGET}/include

		# Avoid collisions for other Hurd targets
		# TODO: autoconf var?
		rm -rfv "${ED}"/usr/share/info || die
	fi
}
