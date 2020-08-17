# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs flag-o-matic

MY_P="${PN}${PV//.}"
DESCRIPTION="Info ZIP (encryption support)"
HOMEPAGE="http://www.info-zip.org/"
SRC_URI="mirror://sourceforge/infozip/${MY_P}.zip"

LICENSE="Info-ZIP"
SLOT="0"
KEYWORDS="~alpha ~amd64 arm arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~x64-cygwin ~amd64-linux ~x86-linux"
IUSE="bzip2 crypt natspec unicode"

DEPEND="${RDEPEND}"
RDEPEND="bzip2? ( app-arch/bzip2 )
	natspec? ( dev-libs/libnatspec )"
BDEPEND="app-arch/unzip"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}/${P}"-no-crypt.patch #238398
	"${FILESDIR}/${P}"-pic.patch
	"${FILESDIR}/${P}"-exec-stack.patch #122849
	"${FILESDIR}/${P}"-build.patch #200995
	"${FILESDIR}/${P}"-zipnote-freeze.patch #322047
	"${FILESDIR}/${P}"-format-security.patch #512414
)

src_prepare() {
	default
	use natspec && eapply "${FILESDIR}/${PN}"-3.0-natspec.patch #275244
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
