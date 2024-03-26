# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

TL_SOURCE_VERSION=20230311
inherit flag-o-matic toolchain-funcs libtool texlive-common

MY_P=${PN%-core}-${TL_SOURCE_VERSION}-source

DESCRIPTION="A complete TeX distribution"
HOMEPAGE="https://tug.org/texlive/"
SLOT="0"
LICENSE="BSD GPL-1 GPL-2 GPL-2+ GPL-3+ MIT TeX-other-free"
RESTRICT="mirror"
GENTOO_TEX_PATCHES_NUM=3
SRC_URI="
	https://mirrors.ctan.org/systems/texlive/Source/${MY_P}.tar.xz
	https://gitweb.gentoo.org/proj/tex-patches.git/snapshot/tex-patches-${GENTOO_TEX_PATCHES_NUM}.tar.bz2
		-> gentoo-tex-patches-${GENTOO_TEX_PATCHES_NUM}.tar.bz2
"

# Macros that are not a part of texlive-sources or or pulled in from collection-binextra
# but still needed for other packages during installation
TL_CORE_EXTRA_CONTENTS="
	autosp.r58211
	axodraw2.r58155
	chktex.r64797
	detex.r66186
	dvi2tty.r66186
	dvidvi.r65952
	dviljk.r66186
	dvipdfmx.r69127
	dvipos.r66186
	gsftopk.r52851
	hyphen-base.r68321
	lacheck.r66186
	m-tx.r64182
	makeindex.r62517
	pmx.r65926
	texlive-scripts.r69754
	texlive-scripts-extra.r62517
	texlive.infra.r69740
	tpic2pdftex.r52851
	upmendex.r66381
	velthuis.r66186
	vlna.r66186
	xml2pmx.r57972
"
TL_CORE_EXTRA_DOC_CONTENTS="
	autosp.doc.r58211
	axodraw2.doc.r58155
	chktex.doc.r64797
	detex.doc.r66186
	dvi2tty.doc.r66186
	dvidvi.doc.r65952
	dviljk.doc.r66186
	dvipdfmx.doc.r69127
	dvipos.doc.r66186
	gsftopk.doc.r52851
	lacheck.doc.r66186
	m-tx.doc.r64182
	makeindex.doc.r62517
	pmx.doc.r65926
	texlive-scripts.doc.r69754
	texlive-scripts-extra.doc.r62517
	texlive.infra.doc.r69740
	tpic2pdftex.doc.r52851
	upmendex.doc.r66381
	velthuis.doc.r66186
	vlna.doc.r66186
	xml2pmx.doc.r57972
"
TL_CORE_EXTRA_SRC_CONTENTS="
	axodraw2.source.r58155
"

TEXLIVE_MODULE_BINSCRIPTS="
	texmf-dist/scripts/m-tx/m-tx.lua
	texmf-dist/scripts/texlive/fmtutil-sys.sh
	texmf-dist/scripts/texlive/fmtutil-user.sh
	texmf-dist/scripts/texlive/fmtutil.pl
	texmf-dist/scripts/texlive/mktexlsr
	texmf-dist/scripts/texlive/mktexlsr.pl
	texmf-dist/scripts/texlive/mktexmf
	texmf-dist/scripts/texlive/mktexpk
	texmf-dist/scripts/texlive/mktextfm
	texmf-dist/scripts/texlive/rungs.lua
	texmf-dist/scripts/texlive/tlmgr.pl
	texmf-dist/scripts/texlive/updmap-sys.sh
	texmf-dist/scripts/texlive/updmap-user.sh
	texmf-dist/scripts/texlive/updmap.pl
	texmf-dist/scripts/texlive-extra/allcm.sh
	texmf-dist/scripts/texlive-extra/allneeded.sh
	texmf-dist/scripts/texlive-extra/dvi2fax.sh
	texmf-dist/scripts/texlive-extra/dvired.sh
	texmf-dist/scripts/texlive-extra/e2pall.pl
	texmf-dist/scripts/texlive-extra/kpsetool.sh
	texmf-dist/scripts/texlive-extra/kpsewhere.sh
	texmf-dist/scripts/texlive-extra/ps2frag.sh
	texmf-dist/scripts/texlive-extra/pslatex.sh
	texmf-dist/scripts/texlive-extra/texconfig-dialog.sh
	texmf-dist/scripts/texlive-extra/texconfig-sys.sh
	texmf-dist/scripts/texlive-extra/texconfig.sh
	texmf-dist/scripts/texlive-extra/texlinks.sh
"

TEXLIVE_MODULE_BINLINKS="
	fmtutil:mktexfmt
	mktexlsr:texhash
	allcm:allec
	kpsetool:kpsexpand
	kpsetool:kpsepath
"
texlive-common_append_to_src_uri TL_CORE_EXTRA_CONTENTS

SRC_URI+=" doc? ( "
texlive-common_append_to_src_uri TL_CORE_EXTRA_DOC_CONTENTS
SRC_URI+=" )"

SRC_URI+=" source? ( "
texlive-common_append_to_src_uri TL_CORE_EXTRA_SRC_CONTENTS
SRC_URI+=" )"

KEYWORDS="~amd64 ~arm64 ~ppc ~riscv ~x86"
IUSE="cjk X doc source tk +luajittex xetex xindy"

TEXMF_PATH=/usr/share/texmf-dist
MODULAR_X_DEPEND="
	X? (
		x11-libs/libX11
		x11-libs/libXmu
	)"

COMMON_DEPEND="
	${MODULAR_X_DEPEND}
	!app-text/epspdf
	!app-text/pdfjam
	sys-libs/zlib
	>=media-libs/harfbuzz-1.4.5:=[icu,graphite]
	>=media-libs/libpng-1.2.43-r2:0=
	media-libs/gd[png]
	media-gfx/graphite2:=
	media-gfx/potrace:=
	>=x11-libs/cairo-1.12
	>=x11-libs/pixman-0.18
	dev-libs/zziplib:=
	app-text/libpaper:=
	dev-libs/gmp:=
	dev-libs/mpfr:=
	>=dev-libs/ptexenc-1.4.3
	xetex? (
		>=app-text/teckit-2.5.10
		media-libs/fontconfig
	)
	xindy? ( dev-lisp/clisp:= )
	media-libs/freetype:2
	>=dev-libs/icu-50:=
	>=dev-libs/kpathsea-6.3.5:=
"

BDEPEND="
	sys-apps/ed
	sys-devel/flex
	virtual/pkgconfig
"

DEPEND="
	${COMMON_DEPEND}
"

RDEPEND="
	${COMMON_DEPEND}
	virtual/perl-Getopt-Long
	dev-perl/File-HomeDir
	dev-perl/Log-Dispatch
	dev-perl/Unicode-LineBreak
	dev-perl/YAML-Tiny
	tk? (
		dev-lang/tk
		dev-perl/Tk
	)
"

S="${WORKDIR}/${MY_P}"
BUILDDIR="${WORKDIR}/${P}_build"

src_unpack() {
	default

	mkdir -p "${BUILDDIR}" || die "failed to create build dir"
}

RELOC_TARGET=texmf-dist

src_prepare() {
	cd "${WORKDIR}" || die

	# From texlive-module.eclass.
	sed -n -e 's:\s*RELOC/::p' tlpkg/tlpobj/* > "${T}/reloclist" || die
	sed -e 's/\/[^/]*$//' -e "s:^:${RELOC_TARGET}/:" "${T}/reloclist" |
		sort -u |
		xargs mkdir -p || die
	local i
	while read -r i; do
		mv "${i}" "${RELOC_TARGET}/${i%/*}" || die
	done < "${T}/reloclist"
	mv "${WORKDIR}"/texmf* "${S}" || die "failed to move texmf files"

	cd "${S}" || die

	sed -i \
		-e "s,/usr/include /usr/local/include.*echo \$KPATHSEA_INCLUDES.*,$(pkg-config kpathsea --variable=includedir)\"," \
		texk/web2c/configure || die

	local patch_dir="${WORKDIR}/tex-patches-${GENTOO_TEX_PATCHES_NUM}"
	eapply "${patch_dir}"

	default

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

	# revisit/upstream once we bump to 2022, bug #882245
	append-cppflags -D_GNU_SOURCE

	local econf_new_2023=(
		--enable-ptex=no
		--enable-uptex=no
		--enable-autosp=yes
		--enable-axodraw2=yes
		--enable-devnag=yes
		--enable-lacheck=yes
		--enable-m-tx=yes
		--enable-pmx=yes
		--enable-tpic2pdftex=yes
		--with-clisp-runtime=system
		--enable-xml2pmx=yes
		$(use_enable X xpdfopen)
		--enable-web2c=yes
		--enable-afm2pl=yes
		--enable-dvidvi=yes
		--enable-dviljk=yes
		$(use_enable cjk dvipdfm-x)
		--enable-dvipos=yes
		--enable-gregorio=yes
		--enable-gsftopk=yes
		--enable-makeindexk=yes
		--enable-musixtnt=yes
		--enable-seetexk=yes
		--enable-ttfdump=yes
		--enable-upmendex=yes
		--enable-texlive=yes
		--enable-linked-scripts=no
		# web2c afm2pl chktex dtl dvi2tty dvidvi dviljk dviout-util dvipdfm-x gregorio
	)

	tc-export CC CXX AR RANLIB
	cd "${BUILDDIR}" || die
	ECONF_SOURCE="${S}" \
		econf -C \
		--bindir="${EPREFIX}"/usr/bin \
		--datadir="${BUILDDIR}" \
		--with-system-freetype2 \
		--with-system-zlib \
		--with-system-libpng \
		--with-system-teckit \
		--with-teckit-includes="${EPREFIX}"/usr/include/teckit \
		--with-system-kpathsea \
		--with-kpathsea-includes="${EPREFIX}"/usr/include \
		--with-system-icu \
		--with-system-ptexenc \
		--with-system-harfbuzz \
		--with-system-graphite2 \
		--with-system-cairo \
		--with-system-pixman \
		--with-system-zziplib \
		--with-system-libpaper \
		--with-system-gmp \
		--with-system-gd \
		--with-system-mpfr \
		--with-system-potrace \
		--without-texinfo \
		--disable-dialog \
		--disable-multiplatform \
		--enable-chktex \
		--enable-epsfwin \
		--enable-detex \
		--enable-dvi2tty \
		--enable-mftalkwin \
		--enable-regiswin \
		--enable-shared \
		--enable-tektronixwin \
		--enable-unitermwin \
		--enable-vlna \
		--with-ps=gs \
		--disable-psutils \
		--disable-t1utils \
		--enable-ipc \
		--disable-biber \
		--disable-bibtex-x \
		--disable-dvipng \
		--disable-dvipsk \
		--disable-lcdf-typetools \
		--disable-ps2pk \
		--disable-ttf2pk2 \
		--disable-tex4htk \
		--disable-cjkutils \
		--disable-xdvik \
		--enable-luatex \
		--disable-dvisvgm \
		--disable-ps2eps \
		--disable-static \
		--disable-native-texlive-build \
		--disable-largefile \
		--disable-build-in-source-tree \
		--disable-xindy-docs \
		--disable-xindy-rules \
		--with-banner-add=" Gentoo Linux" \
		$(use_enable luajittex) \
		$(use_enable luajittex luajithbtex) \
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
		$(use_with X x) \
		$(use_enable xindy) \
		"${econf_new_2023[@]}"
}

src_compile() {
	cd "${BUILDDIR}" || die
	tc-export CC CXX AR RANLIB

	emake AR="$(tc-getAR)" SHELL="${EPREFIX}"/bin/sh texmf="${EPREFIX}"${TEXMF_PATH:-/usr/share/texmf-dist}

	cd "${S}" || die
	# Mimic updmap --syncwithtrees to enable only fonts installed
	# Code copied from updmap script
	while read -r i; do
		texlive-common_is_file_present_in_texmf "${i}" || echo "${i}"
	done > "${T}/updmap_update" < <(grep -E '^(Mixed|Kanji)?Map' "texmf-dist/web2c/updmap.cfg" | sed 's@.* @@')
	{
		sed 's@/@\\/@g; s@^@/^MixedMap[     ]*@; s@$@$/s/^/#! /@' <"${T}/updmap_update"
		sed 's@/@\\/@g; s@^@/^Map[  ]*@; s@$@$/s/^/#! /@' <"${T}/updmap_update"
		sed 's@/@\\/@g; s@^@/^KanjiMap[     ]*@; s@$@$/s/^/#! /@' <"${T}/updmap_update"
	} > "${T}/updmap_update2"
	sed -f "${T}/updmap_update2" "texmf-dist/web2c/updmap.cfg" >	"${T}/updmap_update3"\
		&& cat "${T}/updmap_update3" > "texmf-dist/web2c/updmap.cfg"
}

src_install() {
	cd "${BUILDDIR}" || die
	dodir ${TEXMF_PATH:-/usr/share/texmf-dist}/web2c

	emake DESTDIR="${D}" texmf="${ED}${TEXMF_PATH:-/usr/share/texmf-dist}" run_texlinks="true" run_mktexlsr="true" install

	cd "${S}" || die
	dodir /usr/share # just in case
	cp -pR texmf-dist "${ED}/usr/share/" || die "failed to install texmf trees"
	cp -pR "${WORKDIR}"/tlpkg "${ED}/usr/share/" || die "failed to install tlpkg files"

	# When X is disabled mf-nowin doesn't exist but some scripts expect it to
	# exist. Instead, it is called mf, so we symlink it to please everything.
	use X || dosym mf /usr/bin/mf-nowin

	docinto texk
	cd "${S}/texk" || die
	dodoc ChangeLog README

	docinto dviljk
	cd "${S}/texk/dviljk" || die
	dodoc ChangeLog README NEWS

	docinto makeindexk
	cd "${S}/texk/makeindexk" || die
	dodoc ChangeLog NOTES README

	docinto web2c
	cd "${S}/texk/web2c" || die
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
	rm -f "${ED}${TEXMF_PATH}/web2c/fmtutil.cnf" || die
	# Remove bundled and invalid updmap.cfg
	rm -f "${ED}/usr/share/texmf-dist/web2c/updmap.cfg" || die

	rm -f "${ED}/usr/bin/"{,u}ptex

	[[ -n ${TEXLIVE_MODULE_BINSCRIPTS} ]] && dobin_texmf_scripts ${TEXLIVE_MODULE_BINSCRIPTS}
	if [[ -n ${TEXLIVE_MODULE_BINLINKS} ]] ; then
		dodir "/usr/bin"
		for i in ${TEXLIVE_MODULE_BINLINKS} ; do
			[[ -f ${ED}/usr/bin/${i%:*} ]] || die "Trying to install an invalid BINLINK ${i%:*}. This should not happen. Please file a bug."
			dosym "${i%:*}" "/usr/bin/${i#*:}"
		done
	fi

	texlive-common_handle_config_files

	# the virtex symlink is not installed
	# The links has to be relative, since the targets
	# is not present at this stage and MacOS doesn't
	# like non-existing targets
	dosym tex /usr/bin/virtex
	dosym pdftex /usr/bin/pdfvirtex

	find "${ED}" -name '*.la' -delete || die
}

pkg_postinst() {
	# Note that the etexmf-update and efmtutil-sys use nonfatal. We are
	# pkg_postinst, so invoking die will merely print an error message
	# but not abort the installation as it already happened. However,
	# unlike the texlive modules, we observed fmtutil-sys failures in
	# texlive-core.

	# TODO: Research the rationale of calling etexmf-update and
	# eftmutil-sys here and the reasons why it sometimes fails.
	nonfatal etexmf-update
	nonfatal efmtutil-sys

	elog
	elog "If you have configuration files in ${EPREFIX}/etc/texmf to merge,"
	elog "please update them and run ${EPREFIX}/usr/sbin/texmf-update."
	elog

	local display_migration_hint=false
	if [[ -n ${REPLACING_VERSIONS} ]]; then
		local new_texlive_version=$(ver_cut 1)
		local replaced_version
		for replaced_version in ${REPLACING_VERSIONS}; do
			replaced_version=$(ver_cut 1 "${replaced_version}")
			if ver_test "${replaced_version}" -lt "${new_texlive_version}" ; then
				display_migration_hint=true
				break
			fi
		done
	fi

	if ! ${display_migration_hint}; then
		return
	fi

	ewarn "If you are migrating from an older TeX distribution"
	ewarn "Please make sure you have read:"
	ewarn "https://wiki.gentoo.org/wiki/Project:TeX/Tex_Live_Migration_Guide"
	ewarn "in order to avoid possible problems"
}
