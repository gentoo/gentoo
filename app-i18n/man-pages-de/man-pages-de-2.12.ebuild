# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

MY_P="${PN/-/}-v${PV}"

DESCRIPTION="A somewhat comprehensive collection of Linux german man page translations"
HOMEPAGE="https://salsa.debian.org/manpages-de-team/manpages-de"
SRC_URI="https://salsa.debian.org/manpages-de-team/manpages-de/-/archive/v${PV}/${MY_P}.tar.bz2"

LICENSE="GPL-3+ man-pages GPL-2+ GPL-2 BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 ~riscv s390 sh sparc x86"
IUSE=""

RDEPEND="virtual/man"
BDEPEND="app-text/po4a"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default

	sed '/gzip --best/d' -i po/Makefile.am || die

	# sys-apps/shadow has it's own translated man-page for this
	local manpage
	local noinst_manpages=(
		upstream/debian-unstable/man1/groups.1
		po/man1/groups.1.po
		po/man1/su.1.po
	)
	for manpage in ${noinst_manpages[@]} ; do
		rm "${manpage}" || die
	done

	# Use the same compression as every other manpage
	local PORTAGE_COMPRESS_LOCAL=${PORTAGE_COMPRESS-bzip2}
	local PORTAGE_COMPRESS_FLAGS_LOCAL=${PORTAGE_COMPRESS_FLAGS}
	if [[ ${PORTAGE_COMPRESS_FLAGS+set} != "set" ]] ; then
		case ${PORTAGE_COMPRESS_LOCAL} in
			bzip2|gzip)
				PORTAGE_COMPRESS_FLAGS_LOCAL="-9"
			;;
		esac
	fi

	# Fix source files for symlinks
	local LINKSOURCE
	case ${PORTAGE_COMPRESS_LOCAL} in
		bzip2)
			for LINKSOURCE in upstream/*/links.txt ; do
				sed -i -e 's/\.gz/\.bz2/g' "${LINKSOURCE}" || die
			done
		;;
		gzip)
			# pass
		;;
		xz)
			for LINKSOURCE in upstream/*/links.txt ; do
				sed -i -e 's/\.gz/\.xz/g' "${LINKSOURCE}" || die
			done
		;;
		*)
			ewarn "Unexpected compression command ${PORTAGE_COMPRESS} found, symlinks will not work."
		;;
	esac

	eautoreconf
}

src_compile() { :; }

src_install() {
	emake mandir="${ED}"/usr/share/man install
	dodoc CHANGES.md README.md
}
