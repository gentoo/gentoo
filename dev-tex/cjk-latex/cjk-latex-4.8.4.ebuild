# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit latex-package elisp-common toolchain-funcs multilib eutils flag-o-matic

MY_P="${P/-latex/}"

DESCRIPTION="A LaTeX 2e macro package which enables the use of CJK scripts in various encodings"
HOMEPAGE="http://cjk.ffii.org/"
# fonts are taken from ftp://ftp.ctan.org/tex-archive/fonts/CJK.zip
SRC_URI="ftp://ftp.ffii.org/pub/cjk/${MY_P}.tar.gz
	mirror://gentoo/${MY_P}-fonts.zip
	doc? ( ftp://ftp.ffii.org/pub/cjk/${MY_P}-doc.tar.gz )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="doc emacs"

RDEPEND="virtual/latex-base
	dev-libs/kpathsea
	emacs? ( virtual/emacs )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	app-arch/unzip"

S="${WORKDIR}/${MY_P}"

src_prepare() {
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
	cd utils
	for d in *conv; do
		cd $d
		local f=`echo $d | tr '[:upper:]' '[:lower:]'`
		echo "all: $f" >> Makefile
		if [ $d = CEFconv ] ; then
			echo "all: cef5conv cefsconv" >> Makefile
		fi
		cd -
	done
	cd hbf2gf
	econf --with-kpathsea-lib="${EPREFIX}"/usr/$(get_libdir) \
		--with-kpathsea-include="${EPREFIX}"/usr/include/kpathsea
}

src_compile() {
	tc-export CC
	cd utils
	for d in *conv; do
		cd $d
		emake || die
		cd -
	done
	cd hbf2gf
	emake || die
	cd -

	if use emacs ; then
		cd lisp
		elisp-compile *.el
		cd emacs
		elisp-compile *.el
		cd ../mule-2.3
		elisp-compile *.el
	fi

	cd "${T}"

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
	cd utils
	for d in *conv; do
		cd $d
		local f=`echo $d | tr '[:upper:]' '[:lower:]'`
		dobin *latex *conv
		doman *.1
		cd -
	done
	cd hbf2gf
	einstall || die "einstall failed"

	cd "${S}"

	# Install pk fonts
	pushd texmf &>/dev/null
	for d in fonts/pk/modeless/*/* ; do
		insinto ${TEXMF}/${d}
		for f in "${T}"/${d##*/}*.pk ; do
			newins $f `basename ${f/.pk/.500pk}` || die "newins failed"
		done
	done
	popd &>/dev/null

	insinto "${TEXMF}/tex/latex/${PN}"
	doins -r texinput/* || die "installing texinput files failed"
	doins -r contrib/wadalab || die "installing wadalab failed"

	if use emacs ; then
		cd utils/lisp
		elisp-install ${PN} *.el{,c} emacs/*.el{,c} mule-2.3/*.el{,c}
	fi

	cd "${S}"

	# uwpatch stuff
	insinto ${TEXMF}/scripts/uwpatch
	doins uwpatch/uwpatchold.sh
	insinto ${TEXMF}/fonts/afm/uwpatch
	doins uwpatch/*.afm

	# jisksp40 stuff
	insinto ${TEXMF}
	doins -r jisksp40/texmf/*

	# kanji48 stuff
	insinto ${TEXMF}
	doins -r kanji48/texmf/*

	use doc || rm -rf texmf/doc
	insinto ${TEXMF}
	doins -r texmf/* || die "installing texmf failed"

	# Move fonts because hbf2gf expects them in MISCFONTS
	mv "${ED}/${TEXMF}/fonts/hbf" "${ED}/${TEXMF}/fonts/misc" || die "mv font failed"

	insinto ${TEXMF}/hbf2gf
	doins utils/hbf2gf/cfg/*

	insinto ${TEXMF}/scripts/subfonts
	doins utils/subfonts/*

	rm -f doc/COPYING doc/INSTALL
	dodoc ChangeLog README
	if use doc ; then
		insinto /usr/share/doc/${PF}
		doins -r doc/*
		doins -r examples
	fi
	docinto uwpatch
	dodoc uwpatch/README
}
