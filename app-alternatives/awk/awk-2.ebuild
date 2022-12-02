# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ALTERNATIVES=(
	gawk:sys-apps/gawk
	busybox:sys-apps/busybox
	mawk:sys-apps/mawk
	nawk:sys-apps/nawk
)

inherit app-alternatives

DESCRIPTION="/bin/awk and /usr/bin/awk symlinks"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="split-usr"

RDEPEND="
	!app-eselect/eselect-awk
"

src_install() {
	local alt=$(get_alternative)
	local root_prefix=
	use split-usr && root_prefix=../../bin/

	# We could consider setting AWK=... like we do for yacc & lex,
	# but it would need some testing with a fair amount of packages first,
	# as autoconf prefers gawk.
	case ${alt} in
		busybox)
			dosym "${root_prefix}busybox" /usr/bin/awk
			;;
		*)
			dosym "${alt}" /usr/bin/awk
			;;
	esac

	newman - awk.1 <<<".so ${alt}.1"

	if use split-usr; then
		dosym ../usr/bin/awk /bin/awk
	fi
}

pkg_postrm() {
	# make sure we don't leave the user without the symlinks, since
	# they've not been owned by any other package
	if [[ ! -h ${EROOT}/usr/bin/awk ]]; then
		ln -s gawk "${EROOT}/usr/bin/awk" || die
	fi
	if [[ ! -h ${EROOT}/bin/awk ]]; then
		ln -s ../usr/bin/awk "${EROOT}/bin/awk" || die
	fi
}
