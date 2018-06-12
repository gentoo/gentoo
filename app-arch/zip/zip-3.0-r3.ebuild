# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="4"
inherit toolchain-funcs eutils flag-o-matic

MY_P="${PN}${PV//.}"
DESCRIPTION="Info ZIP (encryption support)"
HOMEPAGE="http://www.info-zip.org/"
SRC_URI="mirror://sourceforge/infozip/${MY_P}.zip"

LICENSE="Info-ZIP"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~m68k ~mips ppc ppc64 s390 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~arm-linux"
IUSE="bzip2 crypt natspec unicode"

RDEPEND="bzip2? ( app-arch/bzip2 )
	natspec? ( dev-libs/libnatspec )"
DEPEND="${RDEPEND}
	app-arch/unzip"

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch "${FILESDIR}"/${P}-no-crypt.patch #238398
	epatch "${FILESDIR}"/${P}-pic.patch
	epatch "${FILESDIR}"/${P}-exec-stack.patch #122849
	epatch "${FILESDIR}"/${P}-build.patch #200995
	epatch "${FILESDIR}"/${P}-zipnote-freeze.patch #322047
	epatch "${FILESDIR}"/${P}-format-security.patch #512414
	use natspec && epatch "${FILESDIR}"/${PN}-3.0-natspec.patch #275244
}

src_configure() {
	append-cppflags \
		-DLARGE_FILE_SUPPORT \
		-DUIDGID_NOT_16BIT \
		-D$(usex bzip2 '' NO)BZIP2_SUPPORT \
		-D$(usex crypt '' NO)CRYPT \
		-D$(usex unicode '' NO)UNICODE_SUPPORT
	# Third arg disables bzip2 logic as we handle it ourselves above.
	sh ./unix/configure "$(tc-getCC)" "-I. -DUNIX ${CFLAGS} ${CPPFLAGS}" "${T}" || die
	if use bzip2 ; then
		sed -i -e "s:LFLAGS2=:&'-lbz2 ':" flags || die
	fi
}

src_compile() {
	emake \
		CPP="$(tc-getCPP)" \
		-f unix/Makefile generic
}

src_install() {
	dobin zip zipnote zipsplit
	doman man/zip{,note,split}.1
	if use crypt ; then
		dobin zipcloak
		doman man/zipcloak.1
	fi
	dodoc BUGS CHANGES README* TODO WHATSNEW WHERE proginfo/*.txt
}
