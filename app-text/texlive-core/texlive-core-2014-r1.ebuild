# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

#TL_UPSTREAM_PATCHLEVEL="1"
PATCHLEVEL="42"
TL_SOURCE_VERSION=20140525

inherit eutils flag-o-matic toolchain-funcs libtool texlive-common

MY_PV=${PN%-core}-${TL_SOURCE_VERSION}-source

DESCRIPTION="A complete TeX distribution"
HOMEPAGE="http://tug.org/texlive/"
SLOT="0"
LICENSE="GPL-2 LPPL-1.3c TeX"

SRC_URI="mirror://gentoo/${MY_PV}.tar.xz"

# Fetch patches
SRC_URI="${SRC_URI} mirror://gentoo/${PN}-patches-${PATCHLEVEL}.tar.xz"
#	mirror://gentoo/texlive-core-upstream-patches-${TL_UPSTREAM_PATCHLEVEL}.tar.xz"

TL_CORE_BINEXTRA_MODULES="
	a2ping adhocfilelist asymptote bundledoc ctanify ctanupload ctie cweb
	de-macro dtl dtxgen dvi2tty dviasm dvicopy dvidvi dviljk dvipos findhyph
	fragmaster hyphenex installfont lacheck latex-git-log latex2man
	latexfileversion latexpand latexindent ltxfileinfo ltximg listings-ext
	match_parens mkjobtexmf patgen pdfcrop pdftools pfarrei pkfix pkfix-helper
	purifyeps seetexk sty2dtx synctex texcount texdef texdiff texdirflatten
	texdoc texliveonfly texloganalyser texware tie tpic2pdftex typeoutfileinfo
	web collection-binextra
	"
TL_CORE_BINEXTRA_DOC_MODULES="
	a2ping.doc adhocfilelist.doc asymptote.doc bundledoc.doc ctanify.doc
	ctanupload.doc ctie.doc cweb.doc de-macro.doc dtxgen.doc dvi2tty.doc
	dvicopy.doc	dviljk.doc dvipos.doc findhyph.doc fragmaster.doc
	installfont.doc	latex-git-log.doc latex2man.doc latexfileversion.doc
	latexpand.doc latexindent.doc ltxfileinfo.doc ltximg.doc listings-ext.doc
	match_parens.doc mkjobtexmf.doc patgen.doc pdfcrop.doc pdftools.doc
	pfarrei.doc pkfix.doc pkfix-helper.doc purifyeps.doc sty2dtx.doc synctex.doc
	texcount.doc texdef.doc texdiff.doc texdirflatten.doc texdoc.doc
	texliveonfly.doc texloganalyser.doc texware.doc tie.doc tpic2pdftex.doc
	typeoutfileinfo.doc web.doc
	"
TL_CORE_BINEXTRA_SRC_MODULES="
	adhocfilelist.source hyphenex.source listings-ext.source mkjobtexmf.source
	pfarrei.source texdef.source
	"

TL_CORE_EXTRA_MODULES="tetex hyphen-base texconfig gsftopk texlive.infra ${TL_CORE_BINEXTRA_MODULES}"
TL_CORE_EXTRA_DOC_MODULES="tetex.doc texconfig.doc gsftopk.doc texlive.infra.doc ${TL_CORE_BINEXTRA_DOC_MODULES}"
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

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="cjk X doc source tk xetex"

TEXMF_PATH=/usr/share/texmf-dist

MODULAR_X_DEPEND="X? (
				x11-libs/libXmu
				x11-libs/libXp
				x11-libs/libXpm
				x11-libs/libXaw
	)"

COMMON_DEPEND="${MODULAR_X_DEPEND}
	!app-text/ptex
	!app-text/tetex
	!<app-text/texlive-2007
	!app-text/xetex
	!<dev-texlive/texlive-basic-2014
	!<dev-texlive/texlive-metapost-2011
	!app-text/dvibook
	!dev-tex/luatex
	!app-text/dvipdfm
	!app-text/dvipdfmx
	!app-text/xdvipdfmx
	sys-libs/zlib
	>=media-libs/libpng-1.2.43-r2:0=
	>=app-text/poppler-0.12.3-r3:=
	>=x11-libs/cairo-1.12
	>=x11-libs/pixman-0.18
	dev-libs/zziplib
	app-text/libpaper
	xetex? (
		>=media-libs/harfbuzz-0.9.20[icu,graphite]
		>=dev-libs/icu-50:=
		app-text/teckit
		media-libs/fontconfig
		media-gfx/graphite2
	)
	media-libs/freetype:2
	>=dev-libs/kpathsea-6.2.0
	cjk? ( >=dev-libs/ptexenc-1.3.2_p20140525-r1 )"

DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
	sys-apps/ed
	sys-devel/flex
	app-arch/xz-utils"

RDEPEND="${COMMON_DEPEND}
	>=app-text/ps2pkm-1.5_p20130530
	>=app-text/dvipsk-5.993_p20130530
	>=dev-tex/bibtexu-3.71_p20130530
	virtual/perl-Getopt-Long
	tk? ( dev-perl/perl-tk )"

S="${WORKDIR}/${P}_build"
B="${WORKDIR}/${MY_PV}"

src_unpack() {
	unpack ${A}
	mkdir -p "${S}" || die "failed to create build dir"
}

RELOC_TARGET=texmf-dist

src_prepare() {
	cd "${WORKDIR}"
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

	cd "${B}"
	#EPATCH_MULTI_MSG="Applying patches from upstream bugfix branch..." EPATCH_SUFFIX="patch" epatch "${WORKDIR}/gentoo_branch2011_patches"
	EPATCH_SUFFIX="patch" epatch "${WORKDIR}/patches"

	elibtoolize
}

src_configure() {
	# It fails on alpha without this
	use alpha && append-ldflags "-Wl,--no-relax"

	# Too many regexps use A-Z a-z constructs, what causes problems with locales
	# that don't have the same alphabetical order than ascii. Bug #242430
	# So we set LC_ALL to C in order to avoid problems.
	export LC_ALL=C
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
		--disable-ps2pkm \
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
		$(use_enable xetex) \
		$(use_enable cjk ptex) \
		$(use_enable cjk eptex) \
		$(use_enable cjk uptex) \
		$(use_enable cjk euptex) \
		$(use_enable cjk mendexk) \
		$(use_enable cjk makejvf) \
		$(use_enable tk texdoctk) \
		$(use_with X x)
}

src_compile() {
	tc-export CC CXX AR RANLIB
	emake SHELL="${EPREFIX}"/bin/sh texmf="${EPREFIX}"${TEXMF_PATH:-/usr/share/texmf-dist} || die "emake failed"

	cd "${B}"
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
	emake DESTDIR="${D}" texmf="${ED}${TEXMF_PATH:-/usr/share/texmf-dist}" run_texlinks="true" run_mktexlsr="true" install || die "install failed"

	cd "${B}"
	dodir /usr/share # just in case
	cp -pR texmf-dist "${ED}/usr/share/" || die "failed to install texmf trees"
	cp -pR "${WORKDIR}"/tlpkg "${ED}/usr/share/" || die "failed to install tlpkg files"

	# When X is disabled mf-nowin doesn't exist but some scripts expect it to
	# exist. Instead, it is called mf, so we symlink it to please everything.
	use X || dosym mf /usr/bin/mf-nowin

	docinto texk
	cd "${B}/texk"
	dodoc ChangeLog README || die "failed to install texk docs"

	docinto dviljk
	cd "${B}/texk/dviljk"
	dodoc ChangeLog README NEWS || die "failed to install dviljk docs"

	docinto makeindexk
	cd "${B}/texk/makeindexk"
	dodoc ChangeLog NOTES README || die "failed to install makeindexk docs"

	docinto web2c
	cd "${B}/texk/web2c"
	dodoc ChangeLog NEWS PROJECTS README || die "failed to install web2c docs"

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
	mv "${ED}/usr/bin/mpost" "${ED}/usr/bin/mpost-${P}"
	dosym "mpost-${P}" /usr/bin/mpost

	# Ditto for pdftex
	mv "${ED}/usr/bin/pdftex" "${ED}/usr/bin/pdftex-${P}"
	dosym "pdftex-${P}" /usr/bin/pdftex
}

pkg_postinst() {
	etexmf-update

	elog
	elog "If you have configuration files in ${EPREFIX}/etc/texmf to merge,"
	elog "please update them and run ${EPREFIX}/usr/sbin/texmf-update."
	elog
	ewarn "If you are migrating from an older TeX distribution"
	ewarn "Please make sure you have read:"
	ewarn "https://www.gentoo.org/proj/en/tex/texlive-migration-guide.xml"
	ewarn "in order to avoid possible problems"
	elog
	elog "TeXLive has been split in various ebuilds. If you are missing a"
	elog "package to process your TeX documents, you can install"
	elog "dev-tex/texmfind to easily search for them."
	elog
}
