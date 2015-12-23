# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools elisp-common eutils

DESCRIPTION="Free computer algebra environment based on Macsyma"
HOMEPAGE="http://maxima.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2 GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"

# Supported lisps
LISPS=(     sbcl cmucl gcl             ecls clozurecl clisp )
# <lisp> supports readline: . - no, y - yes
SUPP_RL=(   .    .     y               .    .         y     )
# . - just --enable-<lisp>, <flag> - --enable-<flag>
CONF_FLAG=( .    .     .               ecl  ccl       .     )
# patch file version; . - no patch
PATCH_V=(   1    1     .               2    2         1     )

IUSE="emacs tk nls unicode X ${LISPS[*]}"

# Languages
LANGS="es pt pt_BR"
for lang in ${LANGS}; do
	IUSE="${IUSE} linguas_${lang}"
done

# texlive-latexrecommended needed by imaxima for breqn.sty
RDEPEND="!app-emacs/imaxima
	X? ( x11-misc/xdg-utils
		 sci-visualization/gnuplot[gd]
		 tk? ( dev-lang/tk:0 ) )
	emacs? ( virtual/emacs
		virtual/latex-base
		app-emacs/auctex
		app-text/ghostscript-gpl
		dev-texlive/texlive-latexrecommended )"

# generating lisp dependencies
depends() {
	local LISP DEP
	LISP=${LISPS[$1]}
	DEP="dev-lisp/${LISP}:="
	if [ "${SUPP_RL[$1]}" = "." ]; then
		DEP="${DEP} app-misc/rlwrap"
	fi
	echo ${DEP}
}

n=${#LISPS[*]}
for ((n--; n >= 0; n--)); do
	LISP=${LISPS[${n}]}
	RDEPEND="${RDEPEND} ${LISP}? ( $(depends ${n}) )"
	DEF_DEP="${DEF_DEP} !${LISP}? ( "
done

# default lisp
DEF_LISP=0 # sbcl
ARM_LISP=2 # gcl
DEF_DEP="${DEF_DEP} arm? ( `depends ${ARM_LISP}` ) !arm? ( `depends ${DEF_LISP}` )"

n=${#LISPS[*]}
for ((n--; n >= 0; n--)); do
	DEF_DEP="${DEF_DEP} )"
done

unset LISP

RDEPEND="${RDEPEND}
	${DEF_DEP}"

DEPEND="${RDEPEND}
	sys-apps/texinfo"

TEXMF="${EPREFIX}"/usr/share/texmf-site

pkg_setup() {
	local n=${#LISPS[*]}

	for ((n--; n >= 0; n--)); do
		use ${LISPS[${n}]} && NLISPS="${NLISPS} ${n}"
	done

	if [ -z "${NLISPS}" ]; then
		use arm && DEF_LISP=${ARM_LISP}
		ewarn "No lisp specified in USE flags, choosing ${LISPS[${DEF_LISP}]} as default"
		NLISPS=${DEF_LISP}
	fi
}

src_prepare() {
	local n PATCHES v
	PATCHES=( emacs-0 rmaxima-0 wish-2 xdg-utils-0 db-0 )

	n=${#PATCHES[*]}
	for ((n--; n >= 0; n--)); do
		epatch "${FILESDIR}"/${PATCHES[${n}]}.patch
	done

	n=${#LISPS[*]}
	for ((n--; n >= 0; n--)); do
		v=${PATCH_V[${n}]}
		if [ "${v}" != "." ]; then
			epatch "${FILESDIR}"/${LISPS[${n}]}-${v}.patch
		fi
	done

	# bug #343331
	rm share/Makefile.in || die
	rm src/Makefile.in || die
	touch src/*.mk
	touch src/Makefile.am
	eautoreconf
}

src_configure() {
	local CONFS CONF n lang
	for n in ${NLISPS}; do
		CONF=${CONF_FLAG[${n}]}
		if [ ${CONF} = . ]; then
			CONF=${LISPS[${n}]}
		fi
		CONFS="${CONFS} --enable-${CONF}"
	done

	# enable existing translated doc
	if use nls; then
		for lang in ${LANGS}; do
			if use "linguas_${lang}"; then
				CONFS="${CONFS} --enable-lang-${lang}"
				use unicode && CONFS="${CONFS} --enable-lang-${lang}-utf8"
			fi
		done
	fi

	econf ${CONFS} \
		$(use_with tk wish) \
		$(use_enable emacs) \
		--with-lispdir="${EPREFIX}/${SITELISP}/${PN}"
}

src_compile() {
	emake
	use emacs && elisp-compile interfaces/emacs/{emaxima,imaxima}/*.el
}

src_install() {
	docompress -x /usr/share/info
	emake DESTDIR="${D}" emacsdir="${EPREFIX}/${SITELISP}/${PN}" install

	use tk && make_desktop_entry xmaxima xmaxima \
		/usr/share/${PN}/${PV}/xmaxima/maxima-new.png \
		"Science;Math;Education"

	# do not use dodoc because interfaces can't read compressed files
	# read COPYING before attempt to remove it from dodoc
	insinto /usr/share/${PN}/${PV}/doc
	doins AUTHORS COPYING README README.lisps
	dodir /usr/share/doc
	dosym ../${PN}/${PV}/doc /usr/share/doc/${PF}

	if use emacs; then
		elisp-install ${PN} interfaces/emacs/{emaxima,imaxima}/*.{el,elc,lisp}
		elisp-site-file-install "${FILESDIR}"/50maxima-gentoo-1.el

		rm "${ED}"/${SITELISP}/${PN}/emaxima.sty || die
		insinto ${TEXMF}/tex/latex/emaxima
		doins interfaces/emacs/emaxima/emaxima.sty

		insinto /usr/share/${PN}/${PV}/doc/imaxima
		doins interfaces/emacs/imaxima/README
		doins -r interfaces/emacs/imaxima/imath-example
	fi

	# if we use ecls, build an ecls library for maxima
	if use ecls; then
		ECLLIB=`ecl -eval "(princ (SI:GET-LIBRARY-PATHNAME))" -eval "(quit)"`
		insinto "${ECLLIB#${EPREFIX}}"
		doins src/binary-ecl/maxima.fas
	fi
}

pkg_postinst() {
	if use emacs; then
		elisp-site-regen
		mktexlsr
	fi
}

pkg_postrm() {
	if use emacs; then
		elisp-site-regen
		mktexlsr
	fi
}
