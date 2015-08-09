# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# @ECLASS: findlib.eclass
# @MAINTAINER:
# ml@gentoo.org
# @AUTHOR:
# Original author: Matthieu Sozeau <mattam@gentoo.org> (retired)
# @BLURB: ocamlfind (a.k.a. findlib) eclass
# @DESCRIPTION:
# ocamlfind (a.k.a. findlib) eclass



# From this findlib version there is proper stublibs support.
DEPEND=">=dev-ml/findlib-1.0.4-r1"
[[ ${FINDLIB_USE} ]] && DEPEND="${FINDLIB_USE}? ( ${DEPEND} )"

check_ocamlfind() {
	if [ ! -x "${EPREFIX}"/usr/bin/ocamlfind ]
	then
		eerror "In findlib.eclass: could not find the ocamlfind executable"
		eerror "Please report this bug on gentoo's bugzilla, assigning to ml@gentoo.org"
		die "ocamlfind executabled not found"
	fi
}

# @FUNCTION: findlib_src_preinst
# @DESCRIPTION:
# Prepare the image for a findlib installation.
# We use the stublibs style, so no ld.conf needs to be
# updated when a package installs C shared libraries.
findlib_src_preinst() {
	has "${EAPI:-0}" 0 1 2 && ! use prefix && EPREFIX=
	has "${EAPI:-0}" 0 1 2 && use !prefix && ED="${D}"
	check_ocamlfind

	# destdir is the ocaml sitelib
	local destdir=`ocamlfind printconf destdir`

	# strip off prefix
	destdir=${destdir#${EPREFIX}}

	dodir ${destdir} || die "dodir failed"
	export OCAMLFIND_DESTDIR=${ED}${destdir}

	# stublibs style
	dodir ${destdir}/stublibs || die "dodir failed"
	export OCAMLFIND_LDCONF=ignore
}

# @FUNCTION: findlib_src_install
# @DESCRIPTION:
# Install with a properly setup findlib
findlib_src_install() {
	findlib_src_preinst
	make DESTDIR="${D}" "$@" install || die "make failed"
}
