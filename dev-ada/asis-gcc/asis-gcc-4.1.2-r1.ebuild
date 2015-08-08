# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils flag-o-matic gnatbuild

DESCRIPTION="The Ada Semantic Interface Specification (tools tied to compiler). GnuAda version"
HOMEPAGE="http://gnuada.sourceforge.net/"
LICENSE="GMGPL"

KEYWORDS="amd64 x86"

Gnat_Name="gnat-gcc"
My_PN="asis"
SRC_URI="http://dev.gentoo.org/~george/src/${P}.tar.bz2"

IUSE="doc"
RDEPEND="=dev-lang/gnat-gcc-${PV}*"
DEPEND="${RDEPEND}
	doc? ( virtual/latex-base
	app-text/texi2html )"

# overwriting gnatboot's S
S="${WORKDIR}/${My_PN}-${PV}"

# Execstack is not nearly as dangerous in Ada as in C and would require a lot of
# work to work around. See bug #141315.
QA_EXECSTACK="usr/lib/gnat-gcc/*/${SLOT}/adalib/libasis-${SLOT}.so
	usr/lib/gnat-gcc/*/${SLOT}/adalib/libasis.a
	usr/*/gnat-gcc-bin/${SLOT}/*"

# it may be even better to force plain -O2 -pipe here
replace-flags -O3 -O2

# we need to adjust some vars defined in gnatbuild.eclass so that they use
# gnat-gcc instead of asis
My_LIBPATH=${LIBPATH/${PN}/${Gnat_Name}}
My_BINPATH=${BINPATH/${PN}/${Gnat_Name}}
My_DATAPATH=${DATAPATH/${PN}/${Gnat_Name}}

pkg_setup() {
	local currGnat=$(eselect gnat show | grep "gnat-" | awk '{ print $1 }')
	if [[ "${currGnat}" != "${CTARGET}-${Gnat_Name}-${SLOT}" ]]; then
		echo
		eerror "The active gnat profile does not correspond to the selected"
		eerror "version of asis!  Please install the appropriate gnat (if you"
		eerror "did not so yet) and run:"
		eerror "eselect gnat set ${CTARGET}-${Gnat_Name}-${SLOT}"
		eerror "env-update && source /etc/profile"
		eerror "and then emerge =dev-ada/asis-${PV} again.."
		echo
		die
	fi
	if [[ -e ${My_LIBPATH}/adalib/libasis.a ]] ; then
		echo
		ewarn "gnatmake of gnat-gcc unfortunately has problems forcind the build"
		ewarn "if the package is already installed."
		eerror "Please unmerge asis-gcc first and then resume the merge:"
		eerror "emerge --unmerge asis-gcc && emerge asis-gcc"
		echo
		die
	fi
}

# we need to avoid calling gnatboot_src_unpack
src_unpack() {
	unpack ${A}
}

src_compile() {
	# Build the shared library first, we need -fPIC here
	gnatmake -f -Pasis_stat -cargs ${CFLAGS} || die "building libasis.a failed"
	gnatmake -f -Pasis_dyn  -cargs ${CFLAGS} || die "building libasis.so failed"
	chmod 0444 lib/*.ali

	# build tools
	# we need version.o generated for all the tools
	gcc -c -o obj/version.o gnat/version.c
	for fn in gnatelim gnatstub gnatpp ; do
		pushd tools/${fn}
			gnatmake -o ${fn} ${fn}-driver.adb -I../../asis/ -I../../gnat/ \
				-I../tool_utils/ -I../tool_utils/templates/ \
				-L../../lib -cargs ${CFLAGS} -largs -lasis ../../obj/version.o \
				|| die "building ${fn} failed"
		popd
	done
	pushd tools/gnatmetric
		gnatmake -o gnatmetric metrics-simple_driver.adb -I../../asis/ -I../../gnat/ \
			-I../tool_utils/ -I../tool_utils/templates/ \
			-L../../lib -cargs ${CFLAGS} -largs -lasis ../../obj/version.o \
			|| die "building ${fn} failed"
	popd

	pushd tools/adabrowse
		gcc -c util-nl.c
		gnatmake -I../../asis -I../../gnat adabrowse -L../../lib -cargs	${CFLAGS} \
			-largs -lasis ../../obj/version.o || die
	popd
	pushd tools/semtools
		gnatmake -I../../asis -I../../gnat adadep -L../../lib \
			-cargs ${CFLAGS} -largs -lasis ../../obj/version.o || die
		gnatmake -I../../asis -I../../gnat adasubst -L../../lib \
			-cargs ${CFLAGS} -largs -lasis ../../obj/version.o || die
	popd

	# common stuff is just docs in this case
	if use doc; then
		pushd documentation
		make all || die "Failed while compiling documentation"
		for fn in *.ps; do ps2pdf ${fn}; done
		popd
	fi
}

src_install () {
	# install the lib
	dodir ${My_LIBPATH}/adalib
	# doins grossly screws permissions
	cp -dpP lib/* "${D}${My_LIBPATH}"/adalib
	# sources
	insinto ${My_LIBPATH}/adainclude
	doins gnat/*.ad[sb]
	doins asis/*.ad[sb]

	# tools
	mkdir -p "${D}${My_BINPATH}"
	for fn in tools/{adabrowse,gnatelim,gnatstub,gnatpp,gnatmetric}; do
		cp ${fn}/${fn:6} "${D}${My_BINPATH}"
	done
	cp tools/semtools/ada{dep,subst} "${D}${My_BINPATH}"

	# docs and examples
	if use doc ; then
		dodoc documentation/*.{txt,ps}
		dohtml documentation/*.html
		# info's should go into gnat-gpl dirs
		insinto ${My_DATAPATH}/info/
		doins documentation/*.info

		insinto /usr/share/doc/${PF}
		doins -r documentation/*.pdf examples/ tutorial/ templates/
	fi
}

pkg_postinst() {
	echo
	elog "The ASIS is installed for the active gnat compiler at gnat's	location."
	elog "No further configuration is necessary. Enjoy."
	echo
}
