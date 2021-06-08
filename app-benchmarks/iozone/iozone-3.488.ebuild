# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Filesystem benchmarking program"
HOMEPAGE="http://www.iozone.org/"
SRC_URI="http://www.iozone.org/src/current/${PN}${PV/./_}.tar"

LICENSE="freedist"
SLOT="0"
KEYWORDS="amd64 ~arm ~ia64 ppc ppc64 ~sparc x86"

S="${WORKDIR}/${PN}${PV/./_}"

PATCHES=( "${FILESDIR}"/${PN}-3.488-gcc10-fno-common.patch )

src_prepare() {
	default

	# Options FIX
	sed -e '/CC	=.*/d' \
		-e '/CFLAGS	=.*/d' \
		-e 's:-O[23]:$(CFLAGS):g' \
		-e 's:-Dlinux:$(LDFLAGS) -Dlinux:g' \
		-i src/current/makefile || die
}

src_configure() {
	tc-export CC

	case ${ARCH} in
		x86|alpha)  PLATFORM="linux";;
		arm)        PLATFORM="linux-arm";;
		ppc)        PLATFORM="linux-powerpc";;
		ppc64)      PLATFORM="linux-powerpc64";;
		amd64)      PLATFORM="linux-AMD64";;
		ia64)       PLATFORM="linux-ia64";;
		s390)       PLATFORM="linux-S390";;
		*)          PLATFORM="linux-${ARCH}";;
	esac

	# makefile uses $(GCC) in a few places, probably
	# by mistake.
	export GCC=$(tc-getCC)
}

src_compile() {
	emake -C src/current ${PLATFORM}
}

src_test() {
	cd "${T}" || die
	"${S}"/src/current/iozone testfile || die "self test failed"
}

src_install() {
	dosbin src/current/{iozone,fileop}

	# decompress pre-compressed file to make QA check happy
	gunzip docs/Iozone_ps.gz || die

	dodoc docs/I* docs/Run_rules.doc src/current/Changes.txt
	doman docs/iozone.1
	cd src/current || die
	dodoc Generate_Graphs Gnuplot.txt gengnuplot.sh gnu3d.dem
}
