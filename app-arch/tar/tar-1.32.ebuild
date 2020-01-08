# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic

DESCRIPTION="Use this to make tarballs :)"
HOMEPAGE="https://www.gnu.org/software/tar/"
SRC_URI="mirror://gnu/tar/${P}.tar.bz2
	mirror://gnu-alpha/tar/${P}.tar.bz2"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 ~riscv s390 sh sparc x86 ~ppc-aix ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="acl elibc_glibc minimal nls selinux static userland_GNU xattr"

LIB_DEPEND="acl? ( virtual/acl[static-libs(+)] )"

RDEPEND="!static? ( ${LIB_DEPEND//\[static-libs(+)]} )
	selinux? ( sys-libs/libselinux )"
DEPEND="${RDEPEND}
	nls? ( >=sys-devel/gettext-0.10.35 )
	static? ( ${LIB_DEPEND} )
	xattr? ( elibc_glibc? ( sys-apps/attr ) )"

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
	use static && append-ldflags -static
	local myeconfargs=(
		--bindir="${EPREFIX%/}"/bin
		--enable-backup-scripts
		--libexecdir="${EPREFIX%/}"/usr/sbin
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

	mv "${ED%/}"/usr/sbin/${p}backup{,-tar} || die
	mv "${ED%/}"/usr/sbin/${p}restore{,-tar} || die

	if use minimal ; then
		find "${ED%/}"/etc "${ED%/}"/*bin/ "${ED%/}"/usr/*bin/ \
			-type f -a '!' '(' -name tar -o -name ${p}tar ')' \
			-delete || die
	fi
}
