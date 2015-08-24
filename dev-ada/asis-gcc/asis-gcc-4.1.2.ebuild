# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils flag-o-matic gnatbuild

DESCRIPTION="The Ada Semantic Interface Specification (tools tied to compiler). GnuAda version"
HOMEPAGE="http://gnuada.sourceforge.net/"
LICENSE="GMGPL"

KEYWORDS="~amd64 ~x86"

Gnat_Name="gnat-gcc"
My_PN="asis"
# can reuse the same sources, but we need to force an upgrade
My_PV="4.1.1"
SRC_URI="https://dev.gentoo.org/~george/src/${PN}-${My_PV}.tar.bz2"

IUSE="doc"
RDEPEND="=dev-lang/gnat-gcc-${PV}*"
DEPEND="${RDEPEND}
	doc? ( virtual/latex-base
	app-text/texi2html )"

# overwriting gnatboot's S
S="${WORKDIR}/${My_PN}-${My_PV}"

# Execstack is not nearly as dangerous in Ada as in C and would require a lot of
# work to work around. See bug #141315.
QA_EXECSTACK="usr/lib/gnat-gcc/*/${SLOT}/adalib/libasis-4.1.so
	usr/lib/gnat-gcc/*/${SLOT}/adalib/libasis.a
	usr/*/gnat-gcc-bin/${SLOT}/*"

# it may be even better to force plain -O2 -pipe -ftracer here
replace-flags -O3 -O2

pkg_setup() {
	currGnat=$(eselect gnat show | grep "gnat-" | awk '{ print $1 }')
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
}

# we need to avoid calling gnatboot_src_unpack
src_unpack() {
	unpack ${A}
}

src_compile() {
	# Build the shared library first, we need -fPIC here
	gnatmake -Pasis  -cargs ${CFLAGS} || die "building libasis.a failed"
	gnatmake -Pasis_dyn -f -cargs ${CFLAGS} || die "building libasis.so failed"

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
	# we need to adjust some vars defined in gnatbuild.eclass so that they use
	# gnat-gcc instead of asis
	LIBPATH=${LIBPATH/${PN}/${Gnat_Name}}
	BINPATH=${BINPATH/${PN}/${Gnat_Name}}
	DATAPATH=${DATAPATH/${PN}/${Gnat_Name}}

	# install the lib
	dodir ${LIBPATH}/adalib
	chmod 0755 lib_dyn/libasis.so
	cp lib_dyn/libasis.so "${D}${LIBPATH}"/adalib/libasis-${SLOT}.so
	insinto ${LIBPATH}/adalib
	doins obj/*.ali
	chmod 0444 "${D}${LIBPATH}"/adalib/*.ali
	doins lib/libasis.a
	# make appropriate symlinks
	pushd "${D}${LIBPATH}"/adalib
	ln -s libasis-${SLOT}.so libasis.so
	popd
	# sources
	insinto ${LIBPATH}/adainclude
	doins gnat/*.ad[sb]
	doins asis/*.ad[sb]

	# tools
	mkdir -p "${D}${BINPATH}"
	for fn in tools/{adabrowse,gnatelim,gnatstub,gnatpp,gnatmetric}; do
		cp ${fn}/${fn:6} "${D}${BINPATH}"
	done
	cp tools/semtools/ada{dep,subst} "${D}${BINPATH}"

	# docs and examples
	if use doc ; then
		dodoc documentation/*.{txt,ps}
		dohtml documentation/*.html
		# info's should go into gnat-gpl dirs
		insinto ${DATAPATH}/info/
		doins documentation/*.info

		insinto /usr/share/doc/${PF}
		doins -r documentation/*.pdf examples/ tutorial/ templates/

		# this version also provides wiki contents, may be added at some point,
		# however it seems to make sense to just use the online wiki..
	fi
}

pkg_postinst() {
	echo
	elog "The ASIS is installed for the active gnat compiler at gnat's	location."
	elog "No further configuration is necessary. Enjoy."
	echo
}
