# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN="${PN}core"
MY_P="${MY_PN}-${PV}"
inherit flag-o-matic multilib-minimal

DESCRIPTION="High performance/quality MPEG-4 video de-/encoding solution"
HOMEPAGE="https://www.xvid.org/"
SRC_URI="http://downloads.xvid.org/downloads/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="elibc_FreeBSD examples pic +threads"

NASM=">=dev-lang/nasm-2"
YASM=">=dev-lang/yasm-1"

DEPEND="sys-apps/grep
	amd64? ( || ( ${YASM} ${NASM} ) )
	amd64-fbsd? ( ${NASM} )
	x86? ( || ( ${YASM} ${NASM} ) )
	x86-fbsd? ( ${NASM} )
	x86-macos? ( ${NASM} )
	x64-macos? ( ${NASM} )"
RDEPEND=""

S="${WORKDIR}/${MY_PN}/build/generic"

src_prepare() {
	default

	# make build verbose
	sed \
		-e 's/@$(CC)/$(CC)/' \
		-e 's/@$(AS)/$(AS)/' \
		-e 's/@$(RM)/$(RM)/' \
		-e 's/@$(INSTALL)/$(INSTALL)/' \
		-e 's/@cd/cd/' \
		-i Makefile || die
	# Since only the build system is in $S, this will only copy it but not the
	# entire sources.
	multilib_copy_sources
}

multilib_src_configure() {
	use sparc && append-cflags -mno-vis #357149
	use elibc_FreeBSD && export ac_cv_prog_ac_yasm=no #477736

	local myconf=( $(use_enable threads pthread) )
	if use pic || [[ ${ABI} == "x32" ]] ; then #421841
		myconf+=( --disable-assembly )
	fi

	econf "${myconf[@]}"
}

multilib_src_install_all() {
	dodoc "${S}"/../../{AUTHORS,ChangeLog*,CodingStyle,README,TODO}

	if use examples; then
		insinto /usr/share/${PN}
		doins -r "${S}"/../../examples
	fi
}
