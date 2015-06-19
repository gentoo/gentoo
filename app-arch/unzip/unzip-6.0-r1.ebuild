# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/unzip/unzip-6.0-r1.ebuild,v 1.13 2010/08/14 20:10:09 truedfx Exp $

inherit eutils toolchain-funcs flag-o-matic

MY_P="${PN}${PV/.}"

DESCRIPTION="unzipper for pkzip-compressed files"
HOMEPAGE="http://www.info-zip.org/"
SRC_URI="mirror://sourceforge/infozip/${MY_P}.tar.gz"

LICENSE="Info-ZIP"
SLOT="0"
KEYWORDS="~alpha amd64 arm hppa ~ia64 m68k ppc ppc64 s390 sh ~sparc x86"
IUSE="bzip2 unicode"

DEPEND="bzip2? ( app-arch/bzip2 )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-no-exec-stack.patch
	sed -i \
		-e '/^CFLAGS/d' \
		-e '/CFLAGS/s:-O[0-9]\?:$(CFLAGS) $(CPPFLAGS):' \
		-e '/^STRIP/s:=.*:=true:' \
		-e "s:\<CC=gcc\>:CC=\"$(tc-getCC)\":" \
		-e "s:\<LD=gcc\>:LD=\"$(tc-getCC)\":" \
		-e "s:\<AS=gcc\>:AS=\"$(tc-getCC)\":" \
		-e 's:LF2 = -s:LF2 = :' \
		-e 's:LF = :LF = $(LDFLAGS) :' \
		-e 's:SL = :SL = $(LDFLAGS) :' \
		-e 's:FL = :FL = $(LDFLAGS) :' \
		-e "/^#L_BZ2/s:^$(use bzip2 && echo .)::" \
		unix/Makefile \
		|| die "sed unix/Makefile failed"
}

src_compile() {
	local TARGET
	case ${CHOST} in
		i?86*-*linux*)       TARGET=linux_asm ;;
		*linux*)             TARGET=linux_noasm ;;
		i?86*-*bsd* | \
		i?86*-dragonfly*)    TARGET=freebsd ;; # mislabelled bsd with x86 asm
		*bsd* | *dragonfly*) TARGET=bsd ;;
		*-darwin*)           TARGET=macosx ;;
		*) die "Unknown target, you suck" ;;
	esac

	[[ ${CHOST} == *linux* ]] && append-cppflags -DNO_LCHMOD
	use bzip2 && append-cppflags -DUSE_BZIP2
	use unicode && append-cppflags -DUNICODE_SUPPORT -DUNICODE_WCHAR -DUTF8_MAYBE_NATIVE
	append-cppflags -DLARGE_FILE_SUPPORT #281473

	emake \
		-f unix/Makefile \
		${TARGET} || die "emake failed"
}

src_install() {
	dobin unzip funzip unzipsfx unix/zipgrep || die "dobin failed"
	dosym unzip /usr/bin/zipinfo || die
	doman man/*.1
	dodoc BUGS History* README ToDo WHERE
}
