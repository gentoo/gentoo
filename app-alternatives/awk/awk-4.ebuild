# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ALTERNATIVES=(
	gawk:sys-apps/gawk
	busybox:sys-apps/busybox
	mawk:sys-apps/mawk
	nawk:sys-apps/nawk
)

inherit app-alternatives eapi9-ver

DESCRIPTION="/bin/awk and /usr/bin/awk symlinks"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"
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

pkg_preinst() {
	HAD_MAWK=0

	has_version "app-alternatives/awk[mawk]" && HAD_MAWK=1

	ver_replacing -lt 4 && SHOW_MAWK_WARNING=1

	# if we are upgrading from a new enough version, leftover manpage
	# symlink cleanup was done already
	ver_replacing -ge 3 && return

	# otherwise, remove leftover files/symlinks created by eselect-awk (sic!)
	shopt -s nullglob
	local files=( "${EROOT}"/usr/share/man/man1/awk.1* )
	shopt -u nullglob

	if [[ ${files[@]} ]]; then
		einfo "Cleaning up leftover manpage symlinks from eselect-awk ..."
		rm -v "${files[@]}" || die
	fi
}

pkg_postinst() {
	# Show the warning on new installs if using mawk, or older installs
	# if upgrading from < app-alternatives/awk-4[mawk].
	if [[ -z ${REPLACING_VERSIONS} || ${SHOW_MAWK_WARNING} -eq 1 || ${HAD_MAWK} -eq 0 ]] && use mawk; then
		ewarn "mawk (incompletely) implements  awk, as it was defined by the now-obsolete"
		ewarn "POSIX 1003.2 (draft 11.3) specification. It does not fully implement the standard"
		ewarn "extended regular expression syntax and there are other known issues pertaining to POSIX conformance."
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
