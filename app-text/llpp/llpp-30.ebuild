# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils multilib toolchain-funcs # vcs-snapshot git-r3

DESCRIPTION="graphical PDF viewer which aims to superficially resemble less(1)"
HOMEPAGE="http://repo.or.cz/w/llpp.git"
# SRC_URI="https://distfiles.gentoo.org/distfiles/${P}.tar.gz"
#EGIT_REPO_URI="https://repo.or.cz/llpp.git"
#EGIT_COMMIT="273ad1dccd857e2e664530fbb98ca93d68945867"
SRC_URI="https://repo.or.cz/llpp.git/snapshot/273ad1dccd857e2e664530fbb98ca93d68945867.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/llpp-273ad1d"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="+ocamlopt static"

LIB_DEPEND=">=app-text/mupdf-1.12.0:0=[static-libs]
	media-libs/openjpeg:2[static-libs]
	media-libs/fontconfig:1.0[static-libs]
	media-libs/freetype:2[static-libs]
	media-libs/jbig2dec[static-libs]
	sys-libs/zlib[static-libs]
	virtual/jpeg:0[static-libs]
	x11-libs/libX11[static-libs]"
RDEPEND="x11-misc/xsel
	!static? ( ${LIB_DEPEND//\[static-libs]} )"
DEPEND="${RDEPEND}
	static? ( ${LIB_DEPEND}
		app-arch/bzip2[static-libs]
		media-libs/libXcm[static-libs]
		x11-libs/libXau[static-libs]
		x11-libs/libXdmcp[static-libs]
		x11-libs/libXmu[static-libs] )
	>=dev-lang/ocaml-4.02[ocamlopt?]
	dev-ml/lablgl[glut,ocamlopt?]"

RESTRICT="!ocamlopt? ( strip )"

#PATCHES=( "${FILESDIR}"/${PN}-26b-WM_CLASS.patch )

src_compile() {
	local ocaml=$(usex ocamlopt ocamlopt.opt ocamlc.opt)
	local cmo=$(usex ocamlopt cmx cmo)
	local cma=$(usex ocamlopt cmxa cma)
	local ccopt="$(freetype-config --cflags ) -O -include ft2build.h -D_GNU_SOURCE -DUSE_FONTCONFIG -std=c99 -Wextra -Wall -pedantic-errors -Wunused-parameter -Wsign-compare -Wshadow -DKeySym=uint32_t"
	if use static ; then
		local cclib=""
		local slib=""
		local spath=( ${EROOT}usr/$(get_libdir) $($(tc-getPKG_CONFIG) --libs-only-L --static mupdf x11 ${egl} | sed 's:-L::g') )
		for slib in $($(tc-getPKG_CONFIG) --libs-only-l --static mupdf x11 ${egl} fontconfig) -ljpeg -ljbig2dec ; do
			case ${slib} in
				-lm|-ldl|-lpthread)
					einfo "${slib}: shared"
					cclib+="${slib} " ;;
				*)
					local ccnew=$(find ${spath} -name "lib${slib/-l}.a")
					einfo "${slib}: use ${ccnew}"
					cclib+="${ccnew} " ;;
			esac
		done
	else
		local cclib="$($(tc-getPKG_CONFIG) --libs mupdf x11 ${egl} fontconfig) -lpthread"
	fi

	verbose() { echo "$@" >&2 ; "$@" || die ; }
	verbose sh genconfstr.sh > confstruct.ml
	# verbose sh mkhelp.sh KEYS ${PV} > help.ml
	# verbose printf 'let version ="%s";;\n' ${PV} >> help.ml
	verbose ${ocaml} -c -o link.o -ccopt "${ccopt}" link.c
	verbose ${ocaml} -c -o cutils.o -ccopt "${ccopt}" cutils.c
	verbose ${ocaml} -c -o version.o -ccopt "${ccopt}" version.c
	verbose ${ocaml} -c -o xlib.o wsi/x11/xlib.c
	verbose ${ocaml} -c -o keysym2ucs.o -ccopt "-O2 -include inttypes.h -DKeySym=uint32_t" wsi/x11/keysym2ucs.c
	verbose ${ocaml} -c -o keys.${cmo} keys.ml
	verbose ${ocaml} -c -o utils.${cmo} utils.ml
	verbose ${ocaml} -c -o wsi/x11/wsi.cmi wsi/x11/wsi.mli
	verbose ${ocaml} -c -o wsi/x11/wsi.${cmo} -I wsi/x11 wsi/x11/wsi.ml
	verbose ${ocaml} -c -o parser.${cmo} parser.ml
	verbose ${ocaml} -c -o confstruct.${cmo} -I wsi/x11 confstruct.ml
	verbose ${ocaml} -c -o config.${cmo} -I +lablGL -I wsi/x11 config.ml
	verbose ${ocaml} -c -o ffi.${cmo} ffi.ml
	verbose ${ocaml} -c -o help.cmi help.mli
	verbose ${ocaml} -c -o help.${cmo} help.ml
	verbose ${ocaml} -c -o glutils.${cmo} -I +lablGL -I wsi/x11 glutils.ml
	verbose ${ocaml} -c -o utf8syms.${cmo} utf8syms.ml
	verbose ${ocaml} -c -o listview.${cmo} -I +lablGL -I wsi/x11 listview.ml
	verbose ${ocaml} -c -o main.${cmo} -I +lablGL -I wsi/x11 main.ml
	verbose ${ocaml} $(usex ocamlopt "" -custom) -o llpp -I +lablGL -I wsi/x11 \
		str.${cma} unix.${cma} lablgl.${cma} link.o cutils.o version.o xlib.o keysym2ucs.o -cclib "${cclib}" \
		utils.${cmo} parser.${cmo} wsi.${cmo} confstruct.${cmo} config.${cmo} \
		keys.${cmo} utf8syms.${cmo} ffi.${cmo} help.${cmo} glutils.${cmo} listview.${cmo} main.${cmo}
}

src_install() {
	dobin ${PN} misc/${PN}ac
	dodoc README Thanks
}
