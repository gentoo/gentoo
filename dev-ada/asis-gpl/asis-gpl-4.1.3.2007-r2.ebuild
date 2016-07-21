# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils flag-o-matic gnatbuild

ACT_Ver=$(get_version_component_range 4)
Gnat_Name="gnat-gpl"

DESCRIPTION="The Ada Semantic Interface Specification (semantic analysis and tools tied to compiler)"
SRC_URI="mirror://gentoo/${PN}-${ACT_Ver}-src.tgz"
HOMEPAGE="https://libre.adacore.com/"
LICENSE="GPL-2"

KEYWORDS="~amd64 ~x86"

IUSE="doc"
RDEPEND="=dev-lang/gnat-gpl-${PV}*"
DEPEND="${RDEPEND}
	doc? ( virtual/latex-base
	app-text/texi2html )"

S="${WORKDIR}/asis-${ACT_Ver}-src"

# it may be even better to force plain -O2 -pipe -ftracer here
replace-flags -O3 -O2

# we need to adjust some vars defined in gnatbuild.eclass so that they use
# gnat-gpl instead of asis
LIBPATH=${LIBPATH/${PN}/${Gnat_Name}}
BINPATH=${BINPATH/${PN}/${Gnat_Name}}
DATAPATH=${DATAPATH/${PN}/${Gnat_Name}}

QA_EXECSTACK="${BINPATH:1}/*
	${LIBPATH:1}/adalib/libasis-${ACT_Ver}.so"

pkg_setup() {
	currGnat=$(eselect gnat show | grep "gnat-" | awk '{ print $1 }')
	if [[ "${currGnat}" != "${CTARGET}-${Gnat_Name}-${SLOT}" ]]; then
		echo
		eerror "The active gnat profile does not correspond to the selected"
		eerror "version of asis!  Please install the appropriate gnat (if you"
		eerror "did not so yet) and run:"
		eerror "eselect gnat set ${CTARGET}-${Gnat_Name}-${SLOT}"
		eerror "env-update && source /etc/profile"
		eerror "and then emerge =dev-ada/${P} again.."
		echo
		die
	fi
}

# we need to override the eclass defined src_unpack
# and change gcc to gnatgcc where appropriate
src_unpack() {
	unpack ${A}
	cd "${S}"
	for fn in asis/a4g-gnat_int.adb gnat/snames.adb \
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

	# common stuff is just docs in this case
	if use doc; then
		emake -C documentation all || die "Failed while compiling documentation"
	fi
}

src_install () {
	# install the lib
	mkdir -p "${D}${LIBPATH}"/adalib
	chmod 0755 obj/libasis-${ACT_Ver}.so
	cp obj/libasis-${ACT_Ver}.so "${D}${LIBPATH}"/adalib
	insinto ${LIBPATH}/adalib
	doins obj/*.ali lib/libasis.a
	# make appropriate symlinks
	pushd "${D}${LIBPATH}"/adalib
	ln -s libasis-${ACT_Ver}.so libasis.so
	popd
	# sources
	insinto ${LIBPATH}/adainclude
	doins gnat/*.ad[sb]
	doins asis/*.ad[sb]

	# tools
	mkdir -p "${D}${BINPATH}"
	for fn in tools/{asistant,gnat*}; do
		cp ${fn}/${fn:6} "${D}${BINPATH}"
	done

	# docs and examples
	dodoc documentation/*.txt
	dohtml documentation/*.html
	# info's should go into gnat-gpl dirs
	insinto ${DATAPATH}/info/
	doins documentation/*.info

	insinto /usr/share/doc/${PF}
	doins -r documentation/*.pdf examples/ tutorial/ templates/
}

pkg_postinst() {
	echo
	elog "The ASIS is installed for the active gnat compiler at gnat's	location."
	elog "No further configuration is necessary. Enjoy."
	echo
}
