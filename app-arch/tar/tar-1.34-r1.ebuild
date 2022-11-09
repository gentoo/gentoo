# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

VERIFY_SIG_OPENPGP_KEY_PATH="${BROOT}"/usr/share/openpgp-keys/tar.asc
inherit verify-sig

DESCRIPTION="Use this to make tarballs :)"
HOMEPAGE="https://www.gnu.org/software/tar/"
SRC_URI="mirror://gnu/tar/${P}.tar.xz
	https://alpha.gnu.org/gnu/tar/${P}.tar.xz"
SRC_URI+=" verify-sig? (
		mirror://gnu/tar/${P}.tar.xz.sig
		https://alpha.gnu.org/gnu/tar/${P}.tar.xz.sig
	)"

LICENSE="GPL-3+"
SLOT="0"
if [[ -z "$(ver_cut 3)" ]] || [[ "$(ver_cut 3)" -lt 90 ]] ; then
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
fi
IUSE="acl minimal nls selinux xattr"

RDEPEND="
	acl? ( virtual/acl )
	selinux? ( sys-libs/libselinux )
"
DEPEND="${RDEPEND}
	xattr? ( elibc_glibc? ( sys-apps/attr ) )
"
BDEPEND="
	nls? ( sys-devel/gettext )
	verify-sig? ( sec-keys/openpgp-keys-tar )
"

src_configure() {
	local myeconfargs=(
		--bindir="${EPREFIX}"/bin
		--enable-backup-scripts
		--libexecdir="${EPREFIX}"/usr/sbin
		$(use_with acl posix-acls)
		$(use_enable nls)
		$(use_with selinux)
		$(use_with xattr xattrs)

		# autoconf looks for gtar before tar (in configure scripts), hence
		# in Prefix it is important that it is there, otherwise, a gtar from
		# the host system (FreeBSD, Solaris, Darwin) will be found instead
		# of the Prefix provided (GNU) tar
		--program-prefix=g
	)

	FORCE_UNSAFE_CONFIGURE=1 econf "${myeconfargs[@]}"
}

src_install() {
	default

	# a nasty yet required piece of baggage
	exeinto /etc
	doexe "${FILESDIR}"/rmt

	mv "${ED}"/usr/sbin/{gbackup,backup-tar} || die
	mv "${ED}"/usr/sbin/{grestore,restore-tar} || die
	mv "${ED}"/usr/sbin/{g,}backup.sh || die
	mv "${ED}"/usr/sbin/{g,}dump-remind || die

	if use minimal ; then
		find "${ED}"/etc "${ED}"/*bin/ "${ED}"/usr/*bin/ \
			-type f -a '!' -name gtar \
			-delete || die
	fi

	# make tar a symlink
	dosym gtar /bin/tar

	if ! use minimal; then
		dosym grmt /usr/sbin/rmt
	fi

	dosym gtar.1 /usr/share/man/man1/tar.1
	dosym grmt.8 /usr/share/man/man8/rmt.8
}
