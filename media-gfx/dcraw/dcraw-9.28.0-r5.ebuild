# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit readme.gentoo-r1 toolchain-funcs

DESCRIPTION="Command-line decoder for raw digital photos"
HOMEPAGE="https://www.dechifro.org/dcraw/"
SRC_URI="https://www.cybercom.net/~dcoffin/dcraw/archive/${P}.tar.gz
	mirror://gentoo/parse-1.73.tar.bz2"
S="${WORKDIR}/dcraw"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
LANGS=" ca cs de da eo es fr hu it nl pl pt ru sv zh_CN zh_TW"
IUSE="nls jpeg lcms"

DEPEND="
	jpeg? ( media-libs/libjpeg-turbo:0 )
	lcms? ( media-libs/lcms:2 )
"
BDEPEND="
	nls? ( sys-devel/gettext )
"
RDEPEND="${DEPEND}
	media-libs/netpbm
"

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

PATCHES=( "${FILESDIR}/${P}-glibc-2.38.patch"
		  "${FILESDIR}/${P}-fix-LC_CTYPE-undeclared.patch"
)

run_build() {
	einfo "${@}"
	${@} || die
}

src_prepare() {
	default
	rename dcraw_ dcraw. dcraw_*.1 || die "Failed to rename"
}

src_compile() {
	local ECFLAGS="-O2 -DNO_JASPER=yes " # Without optimisation build fails
	local ELIBS="-lm"
	local RP_ECFLAGS="-I/usr/include/gtk-2.0/ -I/usr/include/glib-2.0/ \
		-I/usr/$(get_libdir)/glib-2.0/include -I/usr/include/cairo \
		-I/usr/include/pango-1.0 -I/usr/include/harfbuzz \
		-I/usr/lib64/gtk-2.0/include -I/usr/include/gdk-pixbuf-2.0 \
		-I/usr/include/atk-1.0"

	use lcms && ELIBS="-llcms2 ${ELIBS}" || ECFLAGS+=" -DNO_LCMS=yes"
	use jpeg && ELIBS="-ljpeg ${ELIBS}" || ECFLAGS+=" -DNO_JPEG=yes"
	use nls && ECFLAGS+=" -DLOCALEDIR=\"/usr/share/locale/\""

	run_build $(tc-getCC) ${ECFLAGS} ${CFLAGS} ${LDFLAGS} -o dcraw dcraw.c ${ELIBS}

	run_build $(tc-getCC) -O2 ${CFLAGS} ${LDFLAGS} -o dcparse parse.c

	if use nls; then
		for lang in ${LANGS}; do
			has ${lang} ${LINGUAS-${lang}} \
				&& run_build msgfmt -c -o dcraw_${lang}.mo dcraw_${lang}.po
		done
	fi
}

src_install() {
	dobin dcraw dcparse
	dodoc "${FILESDIR}"/{conversion-examples.txt,dcwrap}

	doman dcraw.1

	if use nls; then
		for lang in ${LANGS}; do
			if has ${lang} ${LINGUAS-${lang}}; then
				[[ -f dcraw.${lang}.1 ]] && doman dcraw.${lang}.1
				insinto /usr/share/locale/${lang}/LC_MESSAGES
				newins dcraw_${lang}.mo dcraw.mo
			fi
		done
	fi

	readme.gentoo_create_doc
}
