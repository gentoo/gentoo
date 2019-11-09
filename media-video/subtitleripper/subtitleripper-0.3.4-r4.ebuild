# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

MY_PV="$(ver_rs 2 "-")"

DESCRIPTION="DVD Subtitle Ripper for Linux"
HOMEPAGE="http://subtitleripper.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}-${MY_PV}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE=""

RDEPEND=">=media-libs/netpbm-10.41.0
	media-libs/libpng
	sys-libs/zlib
	>=app-text/gocr-0.39"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}"

PATCHES=(
	"${FILESDIR}"/${P}-linkingorder.patch
	"${FILESDIR}"/${P}-libpng.patch
	"${FILESDIR}"/${P}-glibc210.patch
	"${FILESDIR}"/${P}-respect-ldflags.patch
)

src_prepare() {
	# PPM library is libnetppm
	sed -i -e "s:ppm:netpbm:g" Makefile || die
	# fix for bug 210435
	sed -i -e "s:#include <ppm.h>:#include <netpbm/ppm.h>:g" \
		spudec.c subtitle2pgm.c || die
	# we will install the gocrfilters into /usr/share/subtitleripper
	sed -i -e 's:~/sourceforge/subtitleripper/src/:/usr/share/subtitleripper:' \
		pgm2txt || die

	default

	# respect CC
	sed -i -e "s:CC =.*:CC = $(tc-getCC):" \
		-e "/^CFLAGS/s: = :& ${CFLAGS} :" "${S}"/Makefile
}

src_install () {
	dobin pgm2txt srttool subtitle2pgm subtitle2vobsub vobsub2pgm

	insinto /usr/share/subtitleripper
	doins gocrfilter_*.sed

	dodoc ChangeLog README*
}
