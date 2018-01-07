# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: Rutils.eclass
# @MAINTAINER:
# root
# @AUTHOR:
# Marco Clocchiatti<ziapannocchia@gmail.com>
# @BLURB:
# utils to install R modules (such as Rcpp  http://rcpp.org).
# @DESCRIPTION:
# provide functions to compile and install a generic R modules.

EXPORT_FUNCTIONS src_unpack src_compile src_install

DEPEND="dev-lang/R"

# @FUNCTION: Rutils_src_unpack
# @USAGE: [ ]
# @DESCRIPTION:
# R modules download  makes ${S} dir 
# needed because I found no way to fetch R packages using $SRC_URI.
Rutils_src_unpack() {
	mkdir -p "$S"
}

# @FUNCTION: Rutils_src_compile
# @USAGE: [ ]
# @DESCRIPTION:
# call R to build package in ${S} dir.
Rutils_src_compile() {
	CMD="install.packages(pkgs='Rcpp',repos='$CRAN_REPO_URI', lib='${S}')"
	/usr/bin/R -q -e "$CMD"
}

# @FUNCTION: Rutils_src_install()
# @USAGE: [ ]
# @DESCRIPTION:
# mv build package from $S to $image.
Rutils_src_install() {
	R_LIBRARY="${ED}/usr/lib/R/library"
	mkdir -p "$R_LIBRARY"
	mv "${PN}" "${R_LIBRARY}"
}
