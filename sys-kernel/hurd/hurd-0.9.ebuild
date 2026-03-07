# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit crossdev flag-o-matic

DESCRIPTION="GNU Hurd is the GNU project's replacement for UNIX"
HOMEPAGE="https://www.gnu.org/software/hurd/hurd.html"

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://git.savannah.gnu.org/git/hurd/hurd.git"
	inherit autotools git-r3
else
	SRC_URI="mirror://gnu/${PN}/${P}.tar.bz2"

	KEYWORDS="~x86"
fi

LICENSE="GPL-2 BSD-2"
SLOT="0"
IUSE="headers-only"

if is_crosspkg ; then
	BDEPEND="
		!headers-only? ( cross-${CTARGET}/mig )
	"
else
	BDEPEND="
		dev-util/mig
	"
fi

src_prepare() {
	default
	[[ ${PV} == 9999 ]] && eautoreconf
}

src_configure() {
	if target_is_not_host ; then
		local sysroot=/usr/${CTARGET}
		export MIG="${CTARGET}-mig"
	fi

	local myeconfargs=(
		--prefix="${EPREFIX}${sysroot}/usr"
		--datadir="${EPREFIX}${sysroot}/usr/share"
		--host=${CTARGET}
	)

	if use headers-only ; then
		myeconfargs+=(
			ac_cv_func_file_exec_paths=no
			ac_cv_func_exec_exec_paths=no
			ac_cv_func__hurd_exec_paths=no
			ac_cv_func__hurd_libc_proc_init=no
			ac_cv_func_mach_port_set_ktype=no
			ac_cv_func_file_utimens=no

			# TODO: Wire these up to not be automagic for
			# USE=-headers-only!
			--without-libcrypt
			--without-parted
			--without-libbz2
			--without-libz
			--without-rump
			--disable-ncursesw
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
	fi
}
