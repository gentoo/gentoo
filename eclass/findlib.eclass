# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: findlib.eclass
# @MAINTAINER:
# ML <ml@gentoo.org>
# @AUTHOR:
# Original author: Matthieu Sozeau <mattam@gentoo.org> (retired)
# @SUPPORTED_EAPIS: 6 7
# @BLURB: ocamlfind (a.k.a. findlib) eclass
# @DESCRIPTION:
# ocamlfind (a.k.a. findlib) eclass

case ${EAPI:-0} in
	[67]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_FINDLIB_ECLASS} ]] ; then
_FINDLIB_ECLASS=1

# Do not complain about CFLAGS etc since ML projects do not use them.
QA_FLAGS_IGNORED='.*'

# Required to use the ocamlopt? dep in RDEPEND below
IUSE="+ocamlopt"

# From this findlib version, there is proper stublibs support.
DEPEND=">=dev-ml/findlib-1.0.4-r1"
[[ ${FINDLIB_USE} ]] && DEPEND="${FINDLIB_USE}? ( ${DEPEND} )"
RDEPEND="dev-lang/ocaml:=[ocamlopt?]"
[[ ${FINDLIB_USE} ]] && RDEPEND="${FINDLIB_USE}? ( ${RDEPEND} )"

check_ocamlfind() {
	if [ ! -x "${EPREFIX}"/usr/bin/ocamlfind ] ; then
		eerror "In ${ECLASS}: could not find the ocamlfind executable"
		eerror "Please report this bug on Gentoo's Bugzilla, assigning to ml@gentoo.org"
		die "ocamlfind executable not found"
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

fi
