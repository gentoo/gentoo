# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH="${BROOT}"/usr/share/openpgp-keys/tar.asc
inherit verify-sig

DESCRIPTION="Use this to make tarballs :)"
HOMEPAGE="https://www.gnu.org/software/tar/"
SRC_URI="
	mirror://gnu/tar/${P}.tar.xz
	https://alpha.gnu.org/gnu/tar/${P}.tar.xz
	verify-sig? (
		mirror://gnu/tar/${P}.tar.xz.sig
		https://alpha.gnu.org/gnu/tar/${P}.tar.xz.sig
	)
"

LICENSE="GPL-3+"
SLOT="0"
if [[ -z "$(ver_cut 3)" || "$(ver_cut 3)" -lt 90 ]] ; then
	KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ppc64 ~riscv ~s390 sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
fi
IUSE="acl minimal nls selinux xattr"

RDEPEND="
	acl? ( virtual/acl )
	selinux? ( sys-libs/libselinux )
"
DEPEND="
	${RDEPEND}
	xattr? ( elibc_glibc? ( sys-apps/attr ) )
"
BDEPEND="
	nls? ( sys-devel/gettext )
	verify-sig? ( sec-keys/openpgp-keys-tar )
"
PDEPEND="
	app-alternatives/tar
"

src_configure() {
	# -fanalyzer doesn't make sense for us in ebuilds, as it's for static analysis
	export gl_cv_warn_c__fanalyzer=no

	local myeconfargs=(
		--bindir="${EPREFIX}"/bin
		# Avoid -Werror
		--disable-gcc-warnings
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

	# Drop CONFIG_SHELL hack after 1.35: https://git.savannah.gnu.org/cgit/tar.git/commit/?id=7687bf4acc4dc4554538389383d7fb4c3e6521cd
	CONFIG_SHELL="${BROOT}"/bin/bash FORCE_UNSAFE_CONFIGURE=1 econf "${myeconfargs[@]}"
}

src_test() {
	# Drop after 1.35: https://git.savannah.gnu.org/cgit/tar.git/commit/?id=18f90676e4695ffcf13413e9fbb24cc0ae2ae9d5
	local -x XZ_OPT= XZ_DEFAULTS=

	default
}

src_install() {
	default

	# A nasty yet required piece of baggage
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

	if ! use minimal; then
		dosym grmt /usr/sbin/rmt
	fi
	dosym grmt.8 /usr/share/man/man8/rmt.8
}

pkg_postinst() {
	# Ensure to preserve the symlink before app-alternatives/tar
	# is installed
	if [[ ! -h ${EROOT}/bin/tar ]]; then
		if [[ -e ${EROOT}/usr/bin/tar ]] ; then
			# bug #904887
			ewarn "${EROOT}/usr/bin/tar exists but is not a symlink."
			ewarn "This is expected during Prefix bootstrap and unusual otherwise."
			ewarn "Moving away unexpected ${EROOT}/usr/bin/tar to .bak."
			mv "${EROOT}/usr/bin/tar" "${EROOT}/usr/bin/tar.bak" || die
		fi
		ln -s gtar "${EROOT}/bin/tar" || die
	fi
}
