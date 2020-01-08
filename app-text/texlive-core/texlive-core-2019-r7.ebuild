# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

TL_SOURCE_VERSION=20190410

inherit flag-o-matic toolchain-funcs libtool texlive-common

MY_P=${PN%-core}-${TL_SOURCE_VERSION}-source

PATCHLEVEL=7

DESCRIPTION="A complete TeX distribution"
HOMEPAGE="https://tug.org/texlive/"
SLOT="0"
LICENSE="GPL-2 LPPL-1.3c TeX"

SRC_URI="mirror://gentoo/${MY_P}.tar.xz
	mirror://gentoo/${PN}-patches-${PV}-${PATCHLEVEL}.tar.xz
	mirror://gentoo/texlive-tlpdb-${PV}.tar.xz"

TL_CORE_BINEXTRA_MODULES="
	a2ping adhocfilelist arara asymptote bundledoc checklistings ctan_chk
	ctanify ctanupload ctie cweb de-macro dtl dtxgen dvi2tty dviasm dvicopy
	dvidvi dviljk dvipos findhyph fragmaster hook-pre-commit-pkg hyphenex
	installfont lacheck latex-git-log latex-papersize latex2man latex2nemeth
	latexfileversion latexpand latexindent ltxfileinfo ltximg listings-ext make4ht
	match_parens mflua mkjobtexmf patgen pdfbook2 pdfcrop pdflatexpicscale pdftools
	pdfxup pfarrei pkfix pkfix-helper purifyeps seetexk srcredact sty2dtx
	synctex tex4ebook texcount texdef texdiff texdirflatten texdoc texfot
	texliveonfly texloganalyser texosquery texware tie tpic2pdftex typeoutfileinfo
	web collection-binextra
	"
TL_CORE_BINEXTRA_DOC_MODULES="
	a2ping.doc adhocfilelist.doc arara.doc asymptote.doc bundledoc.doc
	checklistings.doc ctan_chk.doc ctanify.doc ctanupload.doc ctie.doc
	cweb.doc de-macro.doc dtl.doc dtxgen.doc dvi2tty.doc dviasm.doc dvicopy.doc
	dvidvi.doc dviljk.doc dvipos.doc findhyph.doc fragmaster.doc
	hook-pre-commit-pkg.doc installfont.doc lacheck.doc latex-git-log.doc
	latex-papersize.doc latex2man.doc latex2nemeth.doc latexfileversion.doc
	latexpand.doc latexindent.doc ltxfileinfo.doc ltximg.doc listings-ext.doc
	make4ht.doc match_parens.doc mkjobtexmf.doc patgen.doc pdfbook2.doc pdfcrop.doc
	pdflatexpicscale.doc pdftools.doc pdfxup.doc pfarrei.doc pkfix.doc
	pkfix-helper.doc purifyeps.doc pythontex.doc seetexk.doc srcredact.doc
	sty2dtx.doc synctex.doc tex4ebook.doc texcount.doc texdef.doc texdiff.doc
	texdirflatten.doc texdoc.doc texfot.doc texliveonfly.doc texloganalyser.doc
	texosquery.doc texware.doc tie.doc tpic2pdftex.doc typeoutfileinfo.doc web.doc
"
TL_CORE_BINEXTRA_SRC_MODULES="
	adhocfilelist.source arara.source checklistings.source hyphenex.source
	listings-ext.source mkjobtexmf.source pfarrei.source pythontex.source
	texdef.source texosquery.source
"

TL_CORE_EXTRA_MODULES="tetex hyphen-base gsftopk texlive.infra ${TL_CORE_BINEXTRA_MODULES}"
TL_CORE_EXTRA_DOC_MODULES="tetex.doc gsftopk.doc texlive.infra.doc ${TL_CORE_BINEXTRA_DOC_MODULES}"
TL_CORE_EXTRA_SRC_MODULES="${TL_CORE_BINEXTRA_SRC_MODULES}"

for i in ${TL_CORE_EXTRA_MODULES}; do
	SRC_URI="${SRC_URI} mirror://gentoo/texlive-module-${i}-${PV}.tar.xz"
done

SRC_URI="${SRC_URI} doc? ( "
for i in ${TL_CORE_EXTRA_DOC_MODULES}; do
	SRC_URI="${SRC_URI} mirror://gentoo/texlive-module-${i}-${PV}.tar.xz"
done
SRC_URI="${SRC_URI} )"
SRC_URI="${SRC_URI} source? ( "
for i in ${TL_CORE_EXTRA_SRC_MODULES}; do
	SRC_URI="${SRC_URI} mirror://gentoo/texlive-module-${i}-${PV}.tar.xz"
done
SRC_URI="${SRC_URI} )"

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="cjk X doc source tk +luajittex xetex"

TEXMF_PATH=/usr/share/texmf-dist

MODULAR_X_DEPEND="X? (
				x11-libs/libX11
				x11-libs/libXmu
	)"

COMMON_DEPEND="${MODULAR_X_DEPEND}
	sys-libs/zlib
	>=media-libs/libpng-1.2.43-r2:0=
	media-libs/gd[png]
	>=x11-libs/cairo-1.12
	>=x11-libs/pixman-0.18
	dev-libs/zziplib
	app-text/libpaper
	dev-libs/gmp:0
	dev-libs/mpfr:0=
	xetex? (
		>=media-libs/harfbuzz-1.4.5[icu,graphite]
		>=app-text/teckit-2.5.3
		media-libs/fontconfig
		media-gfx/graphite2
	)
	media-libs/freetype:2
	>=dev-libs/icu-50:=
	>=dev-libs/kpathsea-6.2.3
	cjk? ( >=dev-libs/ptexenc-1.3.7 )
	>=app-text/poppler-0.76.1:="

BDEPEND="sys-apps/ed
	sys-devel/flex
	virtual/pkgconfig"

DEPEND="${COMMON_DEPEND}"

RDEPEND="${COMMON_DEPEND}
	>=app-text/ps2pkm-1.8_p20170524
	>=app-text/dvipsk-5.997
	>=dev-tex/bibtexu-3.71_p20170524
	virtual/perl-Getopt-Long
	tk? ( dev-perl/Tk )"

S="${WORKDIR}/${P}_build"
B="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	mkdir -p "${S}" || die "failed to create build dir"
}

RELOC_TARGET=texmf-dist

src_prepare() {
	cd "${WORKDIR}" || die

	mv texlive.tlpdb tlpkg/ || die "failed to move texlive.tlpdb"

	# From texlive-module.eclass.
	grep -H RELOC tlpkg/tlpobj/* | awk '{print $2}' | sed 's#^RELOC/##' > "${T}/reloclist"
	{ for i in $(<"${T}/reloclist"); do  dirname $i; done; } | uniq > "${T}/dirlist"
	for i in $(<"${T}/dirlist"); do
		[ -d "${RELOC_TARGET}/${i}" ] || mkdir -p "${RELOC_TARGET}/${i}"
	done
	for i in $(<"${T}/reloclist"); do
		mv "${i}" "${RELOC_TARGET}"/$(dirname "${i}") || die "failed to relocate ${i} to ${RELOC_TARGET}/$(dirname ${i})"
	done

	mv "${WORKDIR}"/texmf* "${B}" || die "failed to move texmf files"

	cd "${B}" || die

	default

	# These we need unconditionally
	eapply "${WORKDIR}"/patches/{0001..0006}*.patch

	# Conditional poppler patching
	if has_version ">=app-text/poppler-0.83.0"; then
		eapply "${WORKDIR}"/patches/${P}-poppler083.patch
		eapply "${WORKDIR}"/patches/${P}-poppler084.patch
	else
		eapply "${WORKDIR}"/patches/${P}-poppler076.patch
	fi

	sed -i \
		-e "s,/usr/include /usr/local/include.*echo \$KPATHSEA_INCLUDES.*,${EPREFIX}/usr/include\"," \
		texk/web2c/configure || die

	elibtoolize
}

src_configure() {
	# It fails on alpha without this
	use alpha && append-ldflags "-Wl,--no-relax"

	# Too many regexps use A-Z a-z constructs, what causes problems with locales
	# that don't have the same alphabetical order than ascii. Bug #242430
	# So we set LC_ALL to C in order to avoid problems.
	export LC_ALL=C

	# Disable freetype-config as this is considered obsolete.
	# Also only pkg-config works for prefix as described in bug #690094
	export ac_cv_prog_ac_ct_FT2_CONFIG=no

	tc-export CC CXX AR RANLIB
	ECONF_SOURCE="${B}" \
		econf -C \
		--bindir="${EPREFIX}"/usr/bin \
		--datadir="${S}" \
		--with-system-freetype2 \
		--with-system-zlib \
		--with-system-libpng \
		--with-system-xpdf \
		--with-system-poppler \
		--with-system-teckit \
		--with-teckit-includes="${EPREFIX}"/usr/include/teckit \
		--with-system-kpathsea \
		--with-kpathsea-includes="${EPREFIX}"/usr/include \
		--with-system-icu \
		--with-system-ptexenc \
		--with-system-harfbuzz \
		--with-system-icu \
		--with-system-graphite2 \
		--with-system-cairo \
		--with-system-pixman \
		--with-system-zziplib \
		--with-system-libpaper \
		--with-system-gmp \
		--with-system-gd \
		--with-system-mpfr \
		--without-texinfo \
		--disable-dialog \
		--disable-multiplatform \
		--enable-epsfwin \
		--enable-mftalkwin \
		--enable-regiswin \
		--enable-tektronixwin \
		--enable-unitermwin \
		--with-ps=gs \
		--disable-psutils \
		--disable-t1utils \
		--enable-ipc \
		--disable-biber \
		--disable-bibtex-x \
		--disable-dvipng \
		--disable-dvipsk \
		--disable-chktex \
		--disable-lcdf-typetools \
		--disable-pdfopen \
		--disable-ps2eps \
		--disable-ps2pk \
		--disable-detex \
		--disable-ttf2pk2 \
		--disable-tex4htk \
		--disable-cjkutils \
		--disable-xdvik \
		--disable-xindy \
		--enable-luatex \
		--disable-dvi2tty \
		--disable-dvisvgm \
		--disable-vlna \
		--enable-shared \
		--disable-native-texlive-build \
		--disable-largefile \
		--disable-build-in-source-tree \
		--with-banner-add=" Gentoo Linux" \
		$(use_enable luajittex) \
		$(use_enable luajittex mfluajit) \
		$(use_enable xetex) \
		$(use_enable cjk dviout-util) \
		$(use_enable cjk ptex) \
		$(use_enable cjk eptex) \
		$(use_enable cjk uptex) \
		$(use_enable cjk euptex) \
		$(use_enable cjk mendexk) \
		$(use_enable cjk makejvf) \
		$(use_enable cjk pmp) \
		$(use_enable cjk upmp) \
		$(use_enable tk texdoctk) \
		$(use_with X x)
}

src_compile() {
	tc-export CC CXX AR RANLIB
	emake AR="$(tc-getAR)" SHELL="${EPREFIX}"/bin/sh texmf="${EPREFIX}"${TEXMF_PATH:-/usr/share/texmf-dist}

	cd "${B}" || die
	# Mimic updmap --syncwithtrees to enable only fonts installed
	# Code copied from updmap script
	for i in `egrep '^(Mixed|Kanji)?Map' "texmf-dist/web2c/updmap.cfg" | sed 's@.* @@'`; do
		texlive-common_is_file_present_in_texmf "$i" || echo "$i"
	done > "${T}/updmap_update"
	{
		sed 's@/@\\/@g; s@^@/^MixedMap[     ]*@; s@$@$/s/^/#! /@' <"${T}/updmap_update"
		sed 's@/@\\/@g; s@^@/^Map[  ]*@; s@$@$/s/^/#! /@' <"${T}/updmap_update"
		sed 's@/@\\/@g; s@^@/^KanjiMap[     ]*@; s@$@$/s/^/#! /@' <"${T}/updmap_update"
	} > "${T}/updmap_update2"
	sed -f "${T}/updmap_update2" "texmf-dist/web2c/updmap.cfg" >	"${T}/updmap_update3"\
		&& cat "${T}/updmap_update3" > "texmf-dist/web2c/updmap.cfg"
}

src_install() {
	dodir ${TEXMF_PATH:-/usr/share/texmf-dist}/web2c
	emake DESTDIR="${D}" texmf="${ED}${TEXMF_PATH:-/usr/share/texmf-dist}" run_texlinks="true" run_mktexlsr="true" install

	cd "${B}" || die
	dodir /usr/share # just in case
	cp -pR texmf-dist "${ED}/usr/share/" || die "failed to install texmf trees"
	cp -pR "${WORKDIR}"/tlpkg "${ED}/usr/share/" || die "failed to install tlpkg files"

	# When X is disabled mf-nowin doesn't exist but some scripts expect it to
	# exist. Instead, it is called mf, so we symlink it to please everything.
	use X || dosym mf /usr/bin/mf-nowin

	docinto texk
	cd "${B}/texk" || die
	dodoc ChangeLog README

	docinto dviljk
	cd "${B}/texk/dviljk" || die
	dodoc ChangeLog README NEWS

	docinto makeindexk
	cd "${B}/texk/makeindexk" || die
	dodoc ChangeLog NOTES README

	docinto web2c
	cd "${B}/texk/web2c" || die
	dodoc ChangeLog NEWS PROJECTS README

	use doc || rm -rf "${ED}/usr/share/texmf-dist/doc"

	dodir /etc/env.d
	echo 'CONFIG_PROTECT_MASK="/etc/texmf/web2c /etc/texmf/language.dat.d /etc/texmf/language.def.d /etc/texmf/updmap.d"' > "${ED}/etc/env.d/98texlive"
	# populate /etc/texmf
	keepdir /etc/texmf/web2c

	# take care of updmap.cfg and language.d files
	keepdir /etc/texmf/{updmap.d,language.dat.d,language.def.d,language.dat.lua.d}

	mv "${ED}${TEXMF_PATH}/web2c/updmap.cfg" "${ED}/etc/texmf/updmap.d/00updmap.cfg" || die "moving updmap.cfg failed"

	# Remove fmtutil.cnf, it will be regenerated from /etc/texmf/fmtutil.d files
	# by texmf-update
	rm -f "${ED}${TEXMF_PATH}/web2c/fmtutil.cnf"
	# Remove bundled and invalid updmap.cfg
	rm -f "${ED}/usr/share/texmf-dist/web2c/updmap.cfg"

	texlive-common_handle_config_files

	keepdir /usr/share/texmf-site

	# the virtex symlink is not installed
	# The links has to be relative, since the targets
	# is not present at this stage and MacOS doesn't
	# like non-existing targets
	dosym tex /usr/bin/virtex
	dosym pdftex /usr/bin/pdfvirtex

	# Rename mpost to leave room for mplib
	mv "${ED}/usr/bin/mpost" "${ED}/usr/bin/mpost-${P}" || die
	dosym "mpost-${P}" /usr/bin/mpost

	# Ditto for pdftex
	mv "${ED}/usr/bin/pdftex" "${ED}/usr/bin/pdftex-${P}" || die
	dosym "pdftex-${P}" /usr/bin/pdftex
}

pkg_postinst() {
	etexmf-update

	einfo "Regenerating TeX formats"
	fmtutil-sys --all &> /dev/null

	elog
	elog "If you have configuration files in ${EPREFIX}/etc/texmf to merge,"
	elog "please update them and run ${EPREFIX}/usr/sbin/texmf-update."
	elog
	ewarn "If you are migrating from an older TeX distribution"
	ewarn "Please make sure you have read:"
	ewarn "https://wiki.gentoo.org/wiki/Project:TeX/Tex_Live_Migration_Guide"
	ewarn "in order to avoid possible problems"
}
