# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils readme.gentoo toolchain-funcs

DESCRIPTION="command-line decoder for raw digital photos"
HOMEPAGE="http://www.cybercom.net/~dcoffin/dcraw/"
SRC_URI="http://www.cybercom.net/~dcoffin/dcraw/archive/${P}.tar.gz
	mirror://gentoo/parse-1.73.tar.bz2
	gimp? ( mirror://gentoo/rawphoto-1.32.tar.bz2 )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~x86-solaris"
LANGS=" ca cs de da eo es fr hu it nl pl pt ru sv zh_CN zh_TW"
IUSE="nls gimp jpeg jpeg2k lcms ${LANGS// / linguas_}"

COMMON_DEPEND="
	jpeg? ( virtual/jpeg:0 )
	lcms? ( media-libs/lcms:2 )
	jpeg2k? ( media-libs/jasper )
	gimp? ( media-gfx/gimp )
"
DEPEND="${COMMON_DEPEND}
	nls? ( sys-devel/gettext )
	gimp? ( virtual/pkgconfig )
"
RDEPEND="${COMMON_DEPEND}
	media-libs/netpbm
"

S=${WORKDIR}/dcraw

DOC_CONTENTS="
	See conversion-examples.txt.gz on how to convert
	the PPM files produced by dcraw to other image formats.\n

	\nThe functionality of the external program 'fujiturn' was
	incorporated into dcraw and is automatically used now.\n

	\nThere's an example wrapper script included called 'dcwrap'.
	This package also includes 'dcparse', which extracts
	thumbnail images (preferably JPEGs) from any raw digital
	camera formats that have them, and shows table contents.
"

run_build() {
	einfo "${@}"
	${@} || die
}

src_prepare() {
	rename dcraw_ dcraw. dcraw_*.1 || die "Failed to rename"
}

src_compile() {
	local ECFLAGS="-O2" # Without optimisation build fails
	local ELIBS="-lm"

	use lcms && ELIBS="-llcms2 ${ELIBS}" || ECFLAGS+=" -DNO_LCMS=yes"
	use jpeg && ELIBS="-ljpeg ${ELIBS}" || ECFLAGS+=" -DNO_JPEG=yes"
	use jpeg2k && ELIBS="-ljasper ${ELIBS}" || ECFLAGS+=" -DNO_JASPER=yes"
	use nls && ECFLAGS+=" -DLOCALEDIR=\"/usr/share/locale/\""

	run_build $(tc-getCC) ${ECFLAGS} ${CFLAGS} ${LDFLAGS} -o dcraw dcraw.c ${ELIBS}

	run_build $(tc-getCC) -O2 ${CFLAGS} ${LDFLAGS} -o dcparse parse.c

	# rawphoto gimp plugin
	if use gimp; then
		run_build $(tc-getCC) ${CFLAGS} ${LDFLAGS} \
			$(pkg-config --cflags gimpui-2.0) rawphoto.c -o rawphoto \
			$(pkg-config --libs gimpui-2.0)
	fi

	if use nls; then
		for lang in ${LANGS}; do
			use linguas_${lang} && run_build msgfmt -c -o dcraw_${lang}.mo dcraw_${lang}.po
		done
	fi
}

src_install() {
	dobin dcraw dcparse
	dodoc "${FILESDIR}"/{conversion-examples.txt,dcwrap}

	# rawphoto gimp plugin
	if use gimp; then
		insinto "$(pkg-config --variable=gimplibdir gimp-2.0)/plug-ins"
		insopts -m0755
		doins rawphoto
	fi

	doman dcraw.1

	if use nls; then
		for lang in ${LANGS}; do
			if use linguas_${lang}; then
				[[ -f dcraw.${lang}.1 ]] && doman dcraw.${lang}.1
				insinto /usr/share/locale/${lang}/LC_MESSAGES
				newins dcraw_${lang}.mo dcraw.mo || die "failed to install dcraw_${lang}.mo"
			fi
		done
	fi

	readme.gentoo_create_doc
}
