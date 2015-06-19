# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ada/asis-gcc/asis-gcc-4.4.ebuild,v 1.3 2014/07/13 16:23:26 ulm Exp $

inherit eutils flag-o-matic gnatbuild

ACT_Ver="2010"
Gnat_Name="gnat-gcc"

DESCRIPTION="The Ada Semantic Interface Specification (semantic analysis and tools tied to compiler)"
SRC_URI="http://dev.gentoo.org/~george/src/asis-gpl-${ACT_Ver}-src.tgz"
HOMEPAGE="https://libre.adacore.com/"
LICENSE="GPL-2"

KEYWORDS="~amd64 ~x86"

IUSE="doc"
RDEPEND="=dev-lang/gnat-gcc-${SLOT}*"
DEPEND="${RDEPEND}
	doc? ( virtual/latex-base
	app-text/texi2html )"

S="${WORKDIR}/asis-gpl-${ACT_Ver}-src"

# it may be even better to force plain -O2 -pipe -ftracer here
replace-flags -O3 -O2

# we need to adjust some vars defined in gnatbuild.eclass so that they use
# gnat-gcc instead of asis
LIBPATH=${LIBPATH/${PN}/${Gnat_Name}}
BINPATH=${BINPATH/${PN}/${Gnat_Name}}
DATAPATH=${DATAPATH/${PN}/${Gnat_Name}}

#QA_EXECSTACK="${BINPATH:1}/*
#	${LIBPATH:1}/adalib/libasis-${ACT_Ver}.so"

pkg_setup() {
	currGnat=$(eselect gnat show | grep "gnat-" | awk '{ print $1 }')
	if [[ "${currGnat}" != "${CTARGET}-${Gnat_Name}-${SLOT}" ]]; then
		echo
		eerror "The active gnat profile does not correspond to the selected"
		eerror "version of asis!  Please install the appropriate gnat (if you"
		eerror "did not so yet) and run:"
		eerror "eselect gnat set ${CTARGET}-${Gnat_Name}-${SLOT}"
		eerror "env-update && source /etc/profile"
		eerror "and then emerge asis-gcc:${SLOT} again.."
		echo
		die
	fi
	if [[ -e ${LIBPATH}/adalib/libasis.a ]] ; then
		echo
		ewarn "Already installed asis appears to interfer with the build."
		eerror "Please unmerge matching asis-gcc first and then resume the merge:"
		eerror "emerge --unmerge asis-gcc:${SLOT} && emerge asis-gcc"
		echo
		die
	fi
}

# we need to override the eclass defined src_unpack
# and change gcc to gnatgcc where appropriate
src_unpack() {
	unpack ${A}
	cd "${S}"/gnat/
	# newer versions autogen snames.ad?
	# Looks logical to keep it here, as this is a part of source prep
	gnatmake xsnamest.adb
	./xsnamest
	mv snames.ns snames.ads
	mv snames.nb snames.adb
	# need to change gcc -> gnatgcc
	cd "${S}"
	for fn in asis/a4g-gnat_int.adb \
		asis/a4g-contt.adb \
		gnat/snames.adb \
		tools/tool_utils/asis_ul-common.adb \
		tools/gnatmetric/metrics-compute.adb; do
		sed -i -e "s:\"gcc:\"gnatgcc:" ${fn}
	done
}

src_compile() {
	# Build the shared library first, we need -fPIC here
	gnatmake -Pasis_bld -XBLD=prod -XOPSYS=default_Unix -cargs ${CFLAGS} -fPIC \
		|| die "building libasis.a failed"
	gnatgcc -shared -Wl,-soname,libasis-${ACT_Ver}.so \
		-o obj/libasis-${ACT_Ver}.so obj/*.o -lc \
		|| die "building libasis.so failed"

	# build tools
	for fn in tools/*; do
		pushd ${fn}
			gnatmake -P${fn:6}.gpr || die "building ${fn:6} failed"
		popd
	done

	# no point in rebuilding pregenerated docs
	#if use doc; then
	#	emake -C documentation all || die "Failed while compiling documentation"
	#fi
}

src_install () {
	# README asks to run make install, claiming that some sources are built at
	# that point
	make all install prefix="${D}"
	# now manually move all the stuff to proper places
	mkdir -p "${D}${LIBPATH}"
	mv "${D}"lib/asis/ "${D}${LIBPATH}"/adalib
	# install the shared lib
	chmod 0755 obj/libasis-${ACT_Ver}.so
	cp obj/libasis-${ACT_Ver}.so "${D}${LIBPATH}"/adalib
	# make appropriate symlinks
	pushd "${D}${LIBPATH}"/adalib
		ln -s libasis-${ACT_Ver}.so libasis.so
	popd
	# sources
	mv "${D}"include/asis/ "${D}${LIBPATH}"/adainclude

	# tools
	mkdir -p "${D}${BINPATH}"
	find "${S}"/tools/ -type f -executable -exec cp {} "${D}${BINPATH}" \;
	rm -f "${D}${BINPATH}"/Makefile*

	# docs and examples
	cd "${S}"/documentation/
	if use doc; then
		dodoc  *.txt
		dohtml *.html
		cd "${S}"
		insinto /usr/share/doc/${PF}
		doins -r documentation/*.pdf documentation/*.info tutorial/ templates/
	fi

	# cleanup empty dirs
	rm -rf "${D}"/{bin,include,lib,share}
}

pkg_postinst() {
	echo
	elog "The ASIS is installed for the active gnat compiler at gnat's	location."
	elog "No further configuration is necessary. Enjoy."
	echo
}
