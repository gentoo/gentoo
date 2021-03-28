# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic

DESCRIPTION="Use this to make tarballs :)"
HOMEPAGE="https://www.gnu.org/software/tar/"
SRC_URI="mirror://gnu/tar/${P}.tar.xz
	https://alpha.gnu.org/gnu/tar/${P}.tar.xz"

LICENSE="GPL-3+"
SLOT="0"
[[ -n "$(ver_cut 3)" ]] && [[ "$(ver_cut 3)" -ge 90 ]] || \
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="acl elibc_glibc minimal nls selinux userland_GNU xattr"

RDEPEND="
	acl? ( virtual/acl )
	selinux? ( sys-libs/libselinux )
"
DEPEND="${RDEPEND}
	xattr? ( elibc_glibc? ( sys-apps/attr ) )
"
BDEPEND="
	nls? ( sys-devel/gettext )
"

src_prepare() {
	default

	if ! use userland_GNU ; then
		sed -i \
			-e 's:/backup\.sh:/gbackup.sh:' \
			scripts/{backup,dump-remind,restore}.in \
			|| die "sed non-GNU"
	fi
}

src_configure() {
	local myeconfargs=(
		--bindir="${EPREFIX}"/bin
		--enable-backup-scripts
		--libexecdir="${EPREFIX}"/usr/sbin
		$(usex userland_GNU "" "--program-prefix=g")
		$(use_with acl posix-acls)
		$(use_enable nls)
		$(use_with selinux)
		$(use_with xattr xattrs)
	)
	FORCE_UNSAFE_CONFIGURE=1 econf "${myeconfargs[@]}"
}

src_install() {
	default

	local p=$(usex userland_GNU "" "g")
	if [[ -z ${p} ]] ; then
		# a nasty yet required piece of baggage
		exeinto /etc
		doexe "${FILESDIR}"/rmt
	fi

	# autoconf looks for gtar before tar (in configure scripts), hence
	# in Prefix it is important that it is there, otherwise, a gtar from
	# the host system (FreeBSD, Solaris, Darwin) will be found instead
	# of the Prefix provided (GNU) tar
	if use prefix ; then
		dosym tar /bin/gtar
	fi

	mv "${ED}"/usr/sbin/${p}backup{,-tar} || die
	mv "${ED}"/usr/sbin/${p}restore{,-tar} || die

	if use minimal ; then
		find "${ED}"/etc "${ED}"/*bin/ "${ED}"/usr/*bin/ \
			-type f -a '!' '(' -name tar -o -name ${p}tar ')' \
			-delete || die
	fi
}
