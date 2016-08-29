# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# @ECLASS: latex-package.eclass
# @MAINTAINER:
# TeX team <tex@gentoo.org>
# @AUTHOR:
# Matthew Turk <satai@gentoo.org>
# Martin Ehmsen <ehmsen@gentoo.org>
# @BLURB: An eclass for easy installation of LaTeX packages
# @DESCRIPTION:
# This eClass is designed to be easy to use and implement.  The vast majority of
# LaTeX packages will only need to define SRC_URI (and sometimes S) for a
# successful installation.  If fonts need to be installed, then the variable
# SUPPLIER must also be defined.
#
# However, those packages that contain subdirectories must process each
# subdirectory individually.  For example, a package that contains directories
# DIR1 and DIR2 must call latex-package_src_compile() and
# latex-package_src_install() in each directory, as shown here:
#
# src_compile() {
#    cd ${S}
#    cd DIR1
#    latex-package_src_compile
#    cd ..
#    cd DIR2
#    latex-package_src_compile
# }
#
# src_install() {
#    cd ${S}
#    cd DIR1
#    latex-package_src_install
#    cd ..
#    cd DIR2
#    latex-package_src_install
# }
#
# The eClass automatically takes care of rehashing TeX's cache (ls-lR) after
# installation and after removal, as well as creating final documentation from
# TeX files that come with the source.  Note that we break TeX layout standards
# by placing documentation in /usr/share/doc/${PN}
#
# For examples of basic installations, check out dev-tex/aastex and
# dev-tex/leaflet .
#
# NOTE: The CTAN "directory grab" function creates files with different MD5
# signatures EVERY TIME.  For this reason, if you are grabbing from the CTAN,
# you must either grab each file individually, or find a place to mirror an
# archive of them.  (iBiblio)
#
# It inherits base and eutils in EAPI 5 and earlier.

case ${EAPI:-0} in
	0|1|2|3|4|5) inherit base eutils ;;
	6) ;;
	*) die "Unknown EAPI ${EAPI} for ${ECLASS}" ;;
esac

RDEPEND="virtual/latex-base"
DEPEND="${RDEPEND}
	>=sys-apps/texinfo-4.2-r5"
HOMEPAGE="http://www.tug.org/"
TEXMF="/usr/share/texmf-site"

# @ECLASS-VARIABLE: SUPPLIER
# @DESCRIPTION:
# This refers to the font supplier; it should be overridden (see eclass
# DESCRIPTION above)
SUPPLIER="misc"

# @ECLASS-VARIABLE: LATEX_DOC_ARGUMENTS
# @DESCRIPTION:
# When compiling documentation (.tex/.dtx), this variable will be passed
# to pdflatex as additional argument (e.g. -shell-escape). This variable
# must be set after inherit, as it gets automatically cleared otherwise.
LATEX_DOC_ARGUMENTS=""

# Kept for backwards compatibility
latex-package_has_tetex_3() {
	case ${EAPI:-0} in
		0|1|2|3|4|5) return 0 ;;
		*) die "${FUNCNAME} no longer supported in EAPI ${EAPI}" ;;
	esac
}

# @FUNCTION: latex-package_src_doinstall
# @USAGE: [ module ]
# @DESCRIPTION:
# [module] can be one or more of: sh, sty, cls, fd, clo, def, cfg, dvi, ps, pdf,
# tex, dtx, tfm, vf, afm, pfb, ttf, bst, styles, doc, fonts, bin, or all.
# If [module] is not given, all is assumed.
# It installs the files found in the current directory to the standard locations
# for a TeX installation
latex-package_src_doinstall() {
	debug-print function $FUNCNAME $*

	# Avoid generating font cache outside of the sandbox
	export VARTEXFONTS="${T}/fonts"

	# This actually follows the directions for a "single-user" system
	# at http://www.ctan.org/installationadvice/ modified for gentoo.
	[ -z "$1" ] && latex-package_src_install all

	while [ "$1" ]; do
		case $1 in
			"sh")
				for i in `find . -maxdepth 1 -type f -name "*.${1}"`
				do
					dobin $i || die "dobin $i failed"
				done
				;;
			"sty" | "cls" | "fd" | "clo" | "def" | "cfg")
				for i in `find . -maxdepth 1 -type f -name "*.${1}"`
				do
					insinto ${TEXMF}/tex/latex/${PN}
					doins $i || die "doins $i failed"
				done
				;;
			"dvi" | "ps" | "pdf")
				for i in `find . -maxdepth 1 -type f -name "*.${1}"`
				do
					insinto /usr/share/doc/${PF}
					doins $i || die "doins $i failed"
					dosym /usr/share/doc/${PF}/$(basename ${i}) ${TEXMF}/doc/latex/${PN}/${i}
					case "${EAPI:-0}" in
						0|1|2|3) ;;
						*)
							# prevent compression of symlink target
							docompress -x /usr/share/doc/${PF}/$(basename ${i})
							;;
					esac
				done
				;;
			"tex" | "dtx")
				if ! in_iuse doc || use doc ; then
					for i in `find . -maxdepth 1 -type f -name "*.${1}"`
					do
						[ -n "${LATEX_PACKAGE_SKIP}" ] && has ${i##*/} ${LATEX_PACKAGE_SKIP} && continue
						einfo "Making documentation: $i"
						if pdflatex ${LATEX_DOC_ARGUMENTS} --interaction=batchmode $i &> /dev/null ; then
							pdflatex ${LATEX_DOC_ARGUMENTS} --interaction=batchmode $i &> /dev/null || die
						else
							einfo "pdflatex failed, trying texi2dvi"
							texi2dvi -q -c --language=latex $i &> /dev/null || die
						fi
					done
				fi
				;;
			"tfm" | "vf" | "afm")
				for i in `find . -maxdepth 1 -type f -name "*.${1}"`
				do
					insinto ${TEXMF}/fonts/${1}/${SUPPLIER}/${PN}
					doins $i || die "doins $i failed"
				done
				;;
			"pfb")
				for i in `find . -maxdepth 1 -type f -name "*.pfb"`
				do
					insinto ${TEXMF}/fonts/type1/${SUPPLIER}/${PN}
					doins $i || die "doins $i failed"
				done
				;;
			"ttf")
				for i in `find . -maxdepth 1 -type f -name "*.ttf"`
				do
					insinto ${TEXMF}/fonts/truetype/${SUPPLIER}/${PN}
					doins $i || die "doins $i failed"
				done
				;;
			"bst")
				for i in `find . -maxdepth 1 -type f -name "*.bst"`
				do
					insinto ${TEXMF}/bibtex/bst/${PN}
					doins $i || die "doins $i failed"
				done
				;;
			"styles")
				latex-package_src_doinstall sty cls fd clo def cfg bst
				;;
			"doc")
				latex-package_src_doinstall tex dtx dvi ps pdf
				;;
			"fonts")
				latex-package_src_doinstall tfm vf afm pfb ttf
				;;
			"bin")
				latex-package_src_doinstall sh
				;;
			"all")
				latex-package_src_doinstall styles fonts bin doc
				;;
		esac
	shift
	done
}

# @FUNCTION: latex-package_src_compile
# @DESCRIPTION:
# Calls latex for each *.ins in the current directory in order to generate the
# relevant files that will be installed
latex-package_src_compile() {
	debug-print function $FUNCNAME $*
	for i in `find \`pwd\` -maxdepth 1 -type f -name "*.ins"`
	do
		einfo "Extracting from $i"
		latex --interaction=batchmode $i &> /dev/null || die
	done
}

# @FUNCTION: latex-package_src_install
# @DESCRIPTION:
# Installs the package
latex-package_src_install() {
	debug-print function $FUNCNAME $*
	latex-package_src_doinstall all
	if [ -n "${DOCS}" ] ; then
		dodoc ${DOCS}
	fi
}

# @FUNCTION: latex-package_pkg_postinst
# @DESCRIPTION:
# Calls latex-package_rehash to ensure the TeX installation is consistent with
# the kpathsea database
latex-package_pkg_postinst() {
	debug-print function $FUNCNAME $*
	latex-package_rehash
}

# @FUNCTION: latex-package_pkg_postrm
# @DESCRIPTION:
# Calls latex-package_rehash to ensure the TeX installation is consistent with
# the kpathsea database
latex-package_pkg_postrm() {
	debug-print function $FUNCNAME $*
	latex-package_rehash
}

# @FUNCTION: latex-package_rehash
# @DESCRIPTION:
# Rehashes the kpathsea database, according to the current TeX installation
latex-package_rehash() {
	debug-print function $FUNCNAME $*
	texmf-update
}

EXPORT_FUNCTIONS src_compile src_install pkg_postinst pkg_postrm
