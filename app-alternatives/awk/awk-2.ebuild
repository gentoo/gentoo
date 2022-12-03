# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="/bin/awk and /usr/bin/awk symlinks"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Base/Alternatives"
SRC_URI=""
S=${WORKDIR}

LICENSE="CC0-1.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="busybox +gawk mawk nawk split-usr"
REQUIRED_USE="^^ ( busybox gawk mawk nawk )"

RDEPEND="
	busybox? ( sys-apps/busybox )
	gawk? ( sys-apps/gawk )
	mawk? ( sys-apps/mawk )
	nawk? ( sys-apps/nawk )
	!app-eselect/eselect-awk
"

src_install() {
	local root_prefix=
	use split-usr && root_prefix=../../bin/

	# We could consider setting AWK=... like we do for yacc & lex,
	# but it would need some testing with a fair amount of packages first,
	# as autoconf prefers gawk.
	if use busybox; then
		dosym "${root_prefix}busybox" /usr/bin/awk
		newman - awk.1 <<<".so busybox.1"
	elif use gawk; then
		dosym gawk /usr/bin/awk
		newman - awk.1 <<<".so gawk.1"
	elif use mawk; then
		dosym mawk /usr/bin/awk
		newman - awk.1 <<<".so mawk.1"
	elif use nawk; then
		dosym nawk /usr/bin/awk
		newman - awk.1 <<<".so nawk.1"
	else
		die "Invalid USE flag combination (broken REQUIRED_USE?)"
	fi

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
