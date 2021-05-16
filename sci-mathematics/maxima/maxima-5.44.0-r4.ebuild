# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{7,8} )

inherit autotools elisp-common eutils flag-o-matic python-single-r1 xdg-utils

DESCRIPTION="Free computer algebra environment based on Macsyma"
HOMEPAGE="http://maxima.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2 GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

# Supported lisps
LISPS=(     sbcl cmucl gcl             ecls clozurecl clisp )
# <lisp> supports readline: . - no, y - yes
SUPP_RL=(   .    .     y               .    .         y     )
# . - just --enable-<lisp>, <flag> - --enable-<flag>
CONF_FLAG=( .    .     .               ecl  ccl       .     )
# patch file version; . - no patch
PATCH_V=(   2    1     .               4    3         1     )

IUSE="emacs gui nls unicode vtk X test ${LISPS[*]}"
RESTRICT="!test? ( test )"

# Languages
LANGS="de es pt pt_BR"
for lang in ${LANGS}; do
	IUSE="${IUSE} l10n_${lang/_/-}"
done

# texlive-latexrecommended needed by imaxima for breqn.sty
#
# VTK is an optional plotting backend that can be enabled by
# running "draw_renderer: 'vtk;" within maxima.
#
# It's NON-optional for the scene() command, but that command is
# currently useless since Tcl/Tk support was dropped in sci-libs/vtk.
# Thus we include VTK only as an optional dependency.
RDEPEND="
	X? (
		x11-misc/xdg-utils
		sci-visualization/gnuplot[gd]
		vtk? (
			${PYTHON_DEPS}
			sci-libs/vtk[python,rendering,${PYTHON_SINGLE_USEDEP}]
		)
	)
	emacs? (
		>=app-editors/emacs-23.1:*
		virtual/latex-base
		app-emacs/auctex
		app-text/ghostscript-gpl
		dev-texlive/texlive-latexrecommended
	)
	gui? ( dev-lang/tk:0 )"

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

# Maxima can make use of X features like plotting (and launching a PNG
# viewer) from the console, but you can't use the xmaxima GUI without X.
REQUIRED_USE="${PYTHON_REQUIRED_USE} gui? ( X )"

RDEPEND="${RDEPEND}
	${DEF_DEP}"

# Python is used in e.g. doc/info/build_html.sh to build the docs.
DEPEND="${PYTHON_DEPS}
	${RDEPEND}
	test? ( sci-visualization/gnuplot )
	sys-apps/texinfo"

TEXMF="${EPREFIX}"/usr/share/texmf-site

pkg_setup() {
	# Set the PYTHON variable to whatever it should be.
	python-single-r1_pkg_setup

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
	PATCHES=( emacs-0 rmaxima-0 wish-2 xdg-utils-1
			  dont-hardcode-python support-new-vtk )

	n=${#PATCHES[*]}
	for ((n--; n >= 0; n--)); do
		eapply "${FILESDIR}"/${PATCHES[${n}]}.patch
	done

	n=${#LISPS[*]}
	for ((n--; n >= 0; n--)); do
		v=${PATCH_V[${n}]}
		if [ "${v}" != "." ]; then
			eapply "${FILESDIR}"/${LISPS[${n}]}-${v}.patch
		fi
	done

	eapply_user

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
			if use "l10n_${lang/_/-}"; then
				CONFS="${CONFS} --enable-lang-${lang}"
				use unicode && CONFS="${CONFS} --enable-lang-${lang}-utf8"
			fi
		done
	fi

	# Using raw-ldflags fixes the error,
	#
	#   x86_64-pc-linux-gnu/bin/ld: fatal error: -O1 -Wl: invalid option
	#   value (expected an integer): 1 -Wl
	#
	# when building the maxima.fas library for ECL.
	#
	econf ${CONFS} \
		LDFLAGS="$(raw-ldflags)" \
		$(use_with gui wish) \
		$(use_enable emacs) \
		--with-lispdir="${EPREFIX}/${SITELISP}/${PN}"
}

src_compile() {
	# The variable PYTHONBIN is used in one place while building the
	# German documentation. Some day that script should be converted
	# to use the value of @PYTHON@ obtained during ./configure.
	emake PYTHONBIN="${PYTHON}"
	if use emacs; then
		pushd interfaces/emacs/emaxima > /dev/null
		elisp-compile *.el
		popd > /dev/null
		pushd interfaces/emacs/imaxima > /dev/null
		BYTECOMPFLAGS="-L . -L ../emaxima"
		elisp-compile *.el
		popd > /dev/null
	fi
}

src_install() {
	docompress -x /usr/share/info
	emake DESTDIR="${D}" emacsdir="${EPREFIX}/${SITELISP}/${PN}" install

	use gui && make_desktop_entry xmaxima xmaxima \
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

	if use ecls; then
		# Use ECL to find the path where it expects to load packages from.
		ECLLIB=$(ecl -eval "(princ (SI:GET-LIBRARY-PATHNAME))" -eval "(quit)")
		insinto "${ECLLIB#${EPREFIX}}"
		doins src/binary-ecl/maxima.fas
	fi
}

pkg_postinst() {
	xdg_mimeinfo_database_update
	if use emacs; then
		elisp-site-regen
		mktexlsr
	fi
}

pkg_postrm() {
	xdg_mimeinfo_database_update
	if use emacs; then
		elisp-site-regen
		mktexlsr
	fi
}
