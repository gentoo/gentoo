# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit latex-package elisp-common toolchain-funcs flag-o-matic

MY_P="${P/-latex/}"

DESCRIPTION="LaTeX package to use CJK (Chinese/Japanese/Korean) scripts in various encodings"
HOMEPAGE="https://cjk.ffii.org/"
# fonts are taken from ftp://ftp.ctan.org/tex-archive/fonts/CJK.zip
SRC_URI="ftp://ftp.ffii.org/pub/cjk/${MY_P}.tar.gz
	mirror://gentoo/${MY_P}-fonts.zip
	doc? ( ftp://ftp.ffii.org/pub/cjk/${MY_P}-doc.tar.gz )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ppc ppc64 ~s390 ~sh sparc x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE="doc emacs"

RDEPEND="virtual/latex-base
	dev-libs/kpathsea
	emacs? ( >=app-editors/emacs-23.1:* )"

DEPEND="${RDEPEND}"

BDEPEND="app-arch/unzip
	virtual/pkgconfig"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default
	for i in "${WORKDIR}"/CJK/*.tar.gz; do
		tar -xzf ${i} || die "failed to unpack $i"
	done
	find texmf/fonts/hbf -type f -exec cp {} "${T}" \; || die
	sed -i -e "/^pk_files/s/no/yes/" \
		-e "/^dpi_x/s/300/500/" \
		texmf/hbf2gf/*.cfg || die
}

src_configure() {
	has_version '>=dev-libs/kpathsea-6.2.1' && append-cppflags "$($(tc-getPKG_CONFIG) --cflags kpathsea)"
	cd utils || die
	for d in *conv; do
		cd ${d} || die
		local f=`echo ${d} | tr '[:upper:]' '[:lower:]'`
		echo "all: $f" >> Makefile
		if [ ${d} = CEFconv ] ; then
			echo "all: cef5conv cefsconv" >> Makefile
		fi
		cd - || die
	done
	cd hbf2gf || die
	econf --with-kpathsea-lib="${EPREFIX}"/usr/$(get_libdir) \
		--with-kpathsea-include="${EPREFIX}"/usr/include/kpathsea
}

src_compile() {
	tc-export CC
	cd utils || die
	for d in *conv; do
		cd ${d} || die
		emake
		cd - || die
	done
	cd hbf2gf || die
	emake
	cd - || die

	if use emacs ; then
		cd lisp || die
		elisp-compile *.el
		cd emacs || die
		elisp-compile *.el
		cd ../mule-2.3 || die
		elisp-compile *.el
	fi

	cd "${T}" || die

	for f in "${S}"/texmf/hbf2gf/*.cfg ; do
	env TEXMFCNF="${EPREFIX}/etc/texmf/web2c" HBF_TARGET="${S}/texmf/fonts" "${S}/utils/hbf2gf/hbf2gf" $f || die
	done

	einfo "Generating pk fonts"
	for gf in *.gf ; do
		einfo "${gf}"
		gftopk $gf || die
	done
}

src_install() {
	cd utils || die
	for d in *conv; do
		cd ${d} || die
		local f=`echo $d | tr '[:upper:]' '[:lower:]'`
		dobin *latex *conv
		doman *.1
		cd - || die
	done
	cd hbf2gf || die
	doman hbf2gf.1
	dobin hbf2gf
	dodir "${TEXMF}/fonts/hbf"

	cd "${S}" || die

	# Install pk fonts
	pushd texmf &>/dev/null || die
	for d in fonts/pk/modeless/*/* ; do
		insinto ${TEXMF}/${d}
		for f in "${T}"/${d##*/}*.pk ; do
			newins ${f} `basename ${f/.pk/.500pk}`
		done
	done
	popd &>/dev/null || die

	insinto "${TEXMF}/tex/latex/${PN}"
	doins -r texinput
	doins -r contrib/wadalab

	if use emacs ; then
		cd utils/lisp || die
		elisp-install ${PN} *.el{,c} emacs/*.el{,c} mule-2.3/*.el{,c}
	fi

	cd "${S}" || die

	# uwpatch stuff
	insinto ${TEXMF}/scripts/uwpatch
	doins uwpatch/uwpatchold.sh
	insinto ${TEXMF}/fonts/afm/uwpatch
	doins uwpatch/*.afm

	# jisksp40 stuff
	insinto ${TEXMF}
	doins -r jisksp40/texmf

	# kanji48 stuff
	insinto ${TEXMF}
	doins -r kanji48/texmf

	use doc || rm -rf texmf/doc
	insinto ${TEXMF}
	doins -r texmf

	# Move fonts because hbf2gf expects them in MISCFONTS
	mv "${ED}/${TEXMF}/fonts/hbf" "${ED}/${TEXMF}/fonts/misc" || die "mv font failed"

	insinto ${TEXMF}/hbf2gf
	doins -r utils/hbf2gf/cfg/

	insinto ${TEXMF}/scripts/subfonts
	doins -r utils/subfonts/

	rm -f doc/COPYING doc/INSTALL || die
	dodoc ChangeLog README
	if use doc ; then
		insinto /usr/share/doc/${PF}
		doins -r doc
		doins -r examples
	fi
	docinto uwpatch
	dodoc uwpatch/README
}
