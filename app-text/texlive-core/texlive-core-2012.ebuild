# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3

#TL_UPSTREAM_PATCHLEVEL="1"
PATCHLEVEL="36"
TL_SOURCE_VERSION=20120701

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
	a2ping asymptote bibtex8 bundledoc ctanify ctanupload ctie cweb de-macro dtl
	dvi2tty dviasm dvicopy dvidvi dviljk dvipng dvipos findhyph fragmaster
	hyphenex installfont lacheck latex2man latexfileversion latexpand
	listings-ext match_parens mkjobtexmf patgen pdfcrop pdftools pkfix
	pkfix-helper purifyeps seetexk sty2dtx synctex texcount texdef texdiff
	texdirflatten texdoc texliveonfly texloganalyser texware tie tpic2pdftex
	typeoutfileinfo web	collection-binextra
	"
TL_CORE_BINEXTRA_DOC_MODULES="
	a2ping.doc asymptote.doc bibtex8.doc bundledoc.doc ctanify.doc
	ctanupload.doc ctie.doc cweb.doc de-macro.doc dvi2tty.doc dvicopy.doc
	dviljk.doc dvipng.doc dvipos.doc findhyph.doc fragmaster.doc installfont.doc
	latex2man.doc latexfileversion.doc latexpand.doc listings-ext.doc
	match_parens.doc mkjobtexmf.doc patgen.doc pdfcrop.doc pdftools.doc
	pkfix.doc pkfix-helper.doc purifyeps.doc sty2dtx.doc synctex.doc
	texcount.doc texdef.doc texdiff.doc texdirflatten.doc texdoc.doc
	texliveonfly.doc texloganalyser.doc texware.doc tie.doc tpic2pdftex.doc
	typeoutfileinfo web.doc
	"
TL_CORE_BINEXTRA_SRC_MODULES="hyphenex.source listings-ext.source mkjobtexmf.source texdef.source"

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

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd"
IUSE="cjk X doc source tk xetex"

MODULAR_X_DEPEND="X? (
				x11-libs/libXmu
				x11-libs/libXp
				x11-libs/libXpm
				x11-libs/libICE
				x11-libs/libSM
				x11-libs/libXaw
				x11-libs/libXfont
	)"

COMMON_DEPEND="${MODULAR_X_DEPEND}
	!app-text/ptex
	!app-text/tetex
	!<app-text/texlive-2007
	!app-text/xetex
	!<dev-texlive/texlive-basic-2009
	!<dev-texlive/texlive-metapost-2011
	!app-text/dvibook
	sys-libs/zlib
	>=media-libs/libpng-1.2.43-r2:0
	>=app-text/poppler-0.12.3-r3
	xetex? (
		app-text/teckit
		media-libs/fontconfig
		media-libs/freetype:2
		media-libs/silgraphite
	)
	>=dev-libs/kpathsea-6.1.0_p20120701
	cjk? ( >=dev-libs/ptexenc-1.2.0_p20120701 )"

DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
	sys-apps/ed
	sys-devel/flex
	app-arch/xz-utils"

RDEPEND="${COMMON_DEPEND}
	>=app-text/ps2pkm-1.5_p20120701
	>=app-text/dvipsk-5.992_p20120701
	>=dev-tex/bibtexu-3.71_p20120701
	virtual/perl-Getopt-Long
	xetex? ( >=app-text/xdvipdfmx-0.7.8_p20120701 )
	tk? ( dev-perl/perl-tk )"

# texdoc needs luatex.
PDEPEND=">=dev-tex/luatex-0.70"

S="${WORKDIR}/${P}_build"
B="${WORKDIR}/${MY_PV}"

src_prepare() {
	mkdir -p "${S}" || die "failed to create build dir"
	mv "${WORKDIR}"/texmf* "${B}" || die "failed to move texmf files"

	cd "${B}"
	#EPATCH_MULTI_MSG="Applying patches from upstream bugfix branch..." EPATCH_SUFFIX="patch" epatch "${WORKDIR}/gentoo_branch2011_patches"
	EPATCH_SUFFIX="patch" epatch "${WORKDIR}/patches"

	elibtoolize
}

src_configure() {
	# It fails on alpha without this
	use alpha && append-ldflags "-Wl,--no-relax"

	# Bug #265232 and bug #414271:
	if use hppa; then
		append-cppflags "-DU_IS_BIG_ENDIAN=1"
	fi

	# Too many regexps use A-Z a-z constructs, what causes problems with locales
	# that don't have the same alphabetical order than ascii. Bug #242430
	# So we set LC_ALL to C in order to avoid problems.
	export LC_ALL=C
	tc-export CC CXX AR
	ECONF_SOURCE="${B}" \
		econf -C \
		--bindir=/usr/bin \
		--datadir="${S}" \
		--with-system-freetype2 \
		--with-freetype2-include=/usr/include \
		--with-system-zlib \
		--with-system-libpng \
		--with-system-xpdf \
		--with-system-poppler \
		--with-system-teckit \
		--with-teckit-includes=/usr/include/teckit \
		--with-system-graphite \
		--with-system-kpathsea \
		--with-system-icu \
		--with-system-ptexenc \
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
		--disable-bibtexu \
		--disable-dvipng \
		--disable-dvipsk \
		--disable-dvipdfmx \
		--disable-chktex \
		--disable-lcdf-typetools \
		--disable-pdfopen \
		--disable-ps2eps \
		--disable-ps2pkm \
		--disable-detex \
		--disable-ttf2pk \
		--disable-tex4htk \
		--disable-cjkutils \
		--disable-xdvik \
		--disable-xindy \
		--disable-luatex \
		--disable-dvi2tty \
		--disable-dvisvgm \
		--disable-vlna \
		--disable-xdvipdfmx \
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
		$(use_with X x)
}

src_compile() {
	emake SHELL=/bin/sh texmf=${TEXMF_PATH:-/usr/share/texmf} || die "emake failed"

	cd "${B}"
	# Mimic updmap --syncwithtrees to enable only fonts installed
	# Code copied from updmap script
	for i in `egrep '^(Mixed)?Map' "texmf/web2c/updmap.cfg" | sed 's@.* @@'`; do
		texlive-common_is_file_present_in_texmf "$i" || echo "$i"
	done > "${T}/updmap_update"
	{
		sed 's@/@\\/@g; s@^@/^MixedMap[     ]*@; s@$@$/s/^/#! /@' <"${T}/updmap_update"
		sed 's@/@\\/@g; s@^@/^Map[  ]*@; s@$@$/s/^/#! /@' <"${T}/updmap_update"
	} > "${T}/updmap_update2"
	sed -f "${T}/updmap_update2" "texmf/web2c/updmap.cfg" >	"${T}/updmap_update3"\
		&& cat "${T}/updmap_update3" > "texmf/web2c/updmap.cfg"
}

src_test() {
	ewarn "Due to modular layout of texlive ebuilds,"
	ewarn "It would not make much sense to use tests into the ebuild"
	ewarn "And tests would fail anyway"
	ewarn "Alternatively you can try to compile any tex file"
	ewarn "Tex warnings should be considered as errors and reported"
	ewarn "You can also run fmtutil-sys --all and check for errors/warnings there"
}

src_install() {
	dodir ${TEXMF_PATH:-/usr/share/texmf}/web2c
	emake DESTDIR="${D}" texmf="${D}${TEXMF_PATH:-/usr/share/texmf}" run_texlinks="true" run_mktexlsr="true" install || die "install failed"

	cd "${B}"
	dodir /usr/share # just in case
	cp -pR texmf{,-dist} "${D}/usr/share/" || die "failed to install texmf trees"
	cp -pR "${WORKDIR}"/tlpkg "${D}/usr/share/" || die "failed to install tlpkg files"

	newsbin "${FILESDIR}/texmf-update2010" texmf-update

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

	use doc || rm -rf "${D}/usr/share/texmf/doc"
	use doc || rm -rf "${D}/usr/share/texmf-dist/doc"

	dodir /etc/env.d
	echo 'CONFIG_PROTECT_MASK="/etc/texmf/web2c /etc/texmf/language.dat.d /etc/texmf/language.def.d /etc/texmf/updmap.d"' > "${D}/etc/env.d/98texlive"
	# populate /etc/texmf
	keepdir /etc/texmf/web2c

	# take care of updmap.cfg and language.d files
	keepdir /etc/texmf/{updmap.d,language.dat.d,language.def.d,language.dat.lua.d}

	mv "${D}${TEXMF_PATH}/web2c/updmap.cfg"	"${D}/etc/texmf/updmap.d/00updmap.cfg" || die "moving updmap.cfg failed"

	# Remove fmtutil.cnf, it will be regenerated from /etc/texmf/fmtutil.d files
	# by texmf-update
	rm -f "${D}${TEXMF_PATH}/web2c/fmtutil.cnf"
	# Remove bundled and invalid updmap.cfg
	rm -f "${D}/usr/share/texmf-dist/web2c/updmap.cfg"

	texlive-common_handle_config_files

	keepdir /usr/share/texmf-site

	# the virtex symlink is not installed
	# The links has to be relative, since the targets
	# is not present at this stage and MacOS doesn't
	# like non-existing targets
	dosym tex /usr/bin/virtex
	dosym pdftex /usr/bin/pdfvirtex

	# Remove texdoctk if we don't want it
	if ! use tk ; then
		rm -f "${D}/usr/bin/texdoctk" "${D}/usr/share/texmf/scripts/tetex/texdoctk.pl" "${D}/usr/share/man/man1/texdoctk.1" || die "failed to remove texdoc tk!"
	fi

	# Rename mpost to leave room for mplib
	mv "${D}/usr/bin/mpost" "${D}/usr/bin/mpost-${P}"
	dosym "mpost-${P}" /usr/bin/mpost

	# Ditto for pdftex
	mv "${D}/usr/bin/pdftex" "${D}/usr/bin/pdftex-${P}"
	dosym "pdftex-${P}" /usr/bin/pdftex
}

pkg_preinst() {
	# Remove stray files to keep the upgrade path sane
	if has_version =app-text/texlive-core-2007* ; then
		for i in pdftex/pdflatex aleph/aleph aleph/lamed omega/lambda omega/omega xetex/xetex xetex/xelatex tex/tex pdftex/etex pdftex/pdftex pdftex/pdfetex ; do
			for j in log fmt ; do
				local file="${ROOT}/var/lib/texmf/web2c/${i}.${j}"
				if [ -f "${file}" ] ; then
					elog "Removing stray ${file} from TeXLive 2007 install."
					rm -f "${file}"
				fi
			done
		done
		for j in base log ; do
			local file="${ROOT}/var/lib/texmf/web2c/metafont/mf.${j}"
			if [ -f "${file}" ] ; then
				elog "Removing stray ${file} from TeXLive 2007 install."
				rm -f "${file}"
			fi
		done
	fi
}

pkg_postinst() {
	etexmf-update

	elog
	elog "If you have configuration files in /etc/texmf to merge,"
	elog "please update them and run /usr/sbin/texmf-update."
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
