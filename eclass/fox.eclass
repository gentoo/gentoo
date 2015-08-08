# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# @ECLASS: fox.eclass
# @MAINTAINER:
# mabi@gentoo.org
# @BLURB: Functionality required the FOX Toolkit and it's applications
# @DESCRIPTION:
# This eclass allows building SLOT-able FOX Toolkit installations
# (x11-libs/fox: headers, libs, and docs), which are by design
# parallel-installable, while installing only one version of the utils
# (dev-util/reswrap) and apps (app-editors/adie, sci-calculators/calculator,
# x11-misc/pathfinder, and x11-misc/shutterbug).
#
# Version numbering follows the kernel-style odd-even minor version
# designation.  Even-number minor versions are API stable, which patch
# releases aimed mostly at the library; apps generally won't need to be
# bumped for a patch release.
#
# Odd-number versions are development branches with their own SLOT and
# are API unstable; changes are made to the apps, and likely need to be
# bumped together with the library.
#
# Here are sample [R]DEPENDs for the fox apps
#	1.6: 'x11-libs/fox:1.6'
#	1.7: '~x11-libs/fox-${PV}'
#
# EAPI phase trickery borrowed from enlightenment.eclass

inherit autotools versionator


FOX_EXPF="src_unpack src_compile src_install pkg_postinst"
case "${EAPI:-0}" in
	2|3|4|5) FOX_EXPF+=" src_prepare src_configure" ;;
	*) ;;
esac
EXPORT_FUNCTIONS ${FOX_EXPF}

# @ECLASS-VARIABLE: FOX_PV
# @DESCRIPTION:
# The version of the FOX Toolkit provided or required by the package
: ${FOX_PV:=${PV}}

# @ECLASS-VARIABLE: FOXVER
# @INTERNAL
# @DESCRIPTION:
# The major.minor version of FOX_PV, usually acts as $SLOT and is used in
# building the applications
FOXVER=$(get_version_component_range 1-2 ${FOX_PV})

# @ECLASS-VARIABLE: FOX_APPS
# @INTERNAL
# @DESCRIPTION:
# The applications originally packaged in the FOX Toolkit
FOX_APPS="adie calculator pathfinder shutterbug"

# @ECLASS-VARIABLE: FOXCONF
# @DEFAULT_UNSET
# @DESCRIPTION:
# Set this to add additional configuration options during src_configure

DESCRIPTION="C++ based Toolkit for developing Graphical User Interfaces easily and effectively"
HOMEPAGE="http://www.fox-toolkit.org/"
SRC_URI="ftp://ftp.fox-toolkit.org/pub/fox-${FOX_PV}.tar.gz"

IUSE="debug doc profile"

if [[ ${PN} != fox ]] ; then
	FOX_COMPONENT="${FOX_COMPONENT:-${PN}}"
fi

if [[ -z ${FOX_COMPONENT} ]] ; then
	DOXYGEN_DEP="doc? ( app-doc/doxygen )"
fi

if [[ ${PN} != reswrap ]] ; then
	RESWRAP_DEP="dev-util/reswrap"
fi

DEPEND="${DOXYGEN_DEP}
	${RESWRAP_DEP}
	>=sys-apps/sed-4"

S="${WORKDIR}/fox-${FOX_PV}"

fox_src_unpack() {
	unpack ${A}
	cd "${S}"

	has src_prepare ${FOX_EXPF} || fox_src_prepare
}

fox_src_prepare() {
	# fox changed from configure.in to configure.am in 1.6.38
	local confFile="configure.ac"
	[[ -r "configure.in" ]] && confFile="configure.in"

	# Respect system CXXFLAGS
	sed -i -e 's:CXXFLAGS=""::' $confFile || die "sed ${confFile} error"

	# don't strip binaries
	sed -i -e '/LDFLAGS="-s ${LDFLAGS}"/d' $confFile || die "sed ${confFile} error"

	# don't build apps from top-level (i.e. x11-libs/fox)
	# utils == reswrap
	local d
	for d in ${FOX_APPS} utils windows ; do
		sed -i -e "s:${d}::" Makefile.am || die "sed Makefile.am error"
	done

	# use the installed reswrap for everything else
	for d in ${FOX_APPS} chart controlpanel tests ; do
		[[ -d ${d} ]] &&
		(sed -i -e 's:$(top_builddir)/utils/reswrap:reswrap:' \
			${d}/Makefile.am || die "sed ${d}/Makefile.am error")
	done

	# use the installed headers and library for apps
	for d in ${FOX_APPS} ; do
		sed -i \
			-e "s:-I\$(top_srcdir)/include -I\$(top_builddir)/include:-I\$(includedir)/fox-${FOXVER}:" \
			-e 's:$(top_builddir)/src/libFOX:-lFOX:' \
			-e 's:$(top_builddir)/lib/libFOX:-lFOX:' \
			-e 's:\.la::' \
			${d}/Makefile.am || die "sed ${d}/Makefile.am error"
	done

	eautoreconf
}

fox_src_configure() {
	use debug && FOXCONF+=" --enable-debug" \
		  || FOXCONF+=" --enable-release"

	econf ${FOXCONF} \
		  $(use_with profile profiling)
}


fox_src_compile() {
	has src_configure ${FOX_EXPF} || fox_src_configure

	cd "${S}/${FOX_COMPONENT}"
	emake || die "compile error"

	# build class reference docs (FOXVER >= 1.2)
	if use doc && [[ -z ${FOX_COMPONENT} ]] ; then
		emake -C "${S}"/doc docs  || die "doxygen error"
	fi
}

fox_src_install() {
	cd "${S}/${FOX_COMPONENT}"

	emake install \
		DESTDIR="${D}" \
		htmldir=/usr/share/doc/${PF}/html \
		artdir=/usr/share/doc/${PF}/html/art \
		screenshotsdir=/usr/share/doc/${PF}/html/screenshots \
		|| die "install error"

	# create desktop menu items for apps
	case ${FOX_COMPONENT} in
		adie)
			newicon big_gif.gif adie.gif
			make_desktop_entry adie "Adie Text Editor" adie.gif
			;;
		calculator)
			newicon bigcalc.gif foxcalc.gif
			make_desktop_entry calculator "FOX Calculator" foxcalc.gif
			;;
		pathfinder)
			newicon iconpath.gif pathfinder.gif
			make_desktop_entry PathFinder "PathFinder" pathfinder.gif "FileManager"
			;;
		shutterbug)
			doicon shutterbug.gif
			make_desktop_entry shutterbug "ShutterBug" shutterbug.gif "Graphics"
			;;
	esac

	for doc in ADDITIONS AUTHORS LICENSE_ADDENDUM README TRACING ; do
		[ -f $doc ] && dodoc $doc
	done

	# remove documentation if USE=-doc
	use doc || rm -fr "${D}/usr/share/doc/${PF}/html"

	# install class reference docs if USE=doc
	if use doc && [[ -z ${FOX_COMPONENT} ]] ; then
		dohtml -r "${S}/doc/ref"
	fi

	# slot fox-config
	if [[ -f ${D}/usr/bin/fox-config ]] ; then
		mv "${D}/usr/bin/fox-config" "${D}/usr/bin/fox-${FOXVER}-config" \
		|| die "failed to install fox-config"
	fi
}

fox_pkg_postinst() {
	if [ -z "${FOX_COMPONENT}" ] ; then
		echo
		einfo "Multiple versions of the FOX Toolkit library may now be installed"
		einfo "in parallel SLOTs on the same system."
		einfo
		einfo "The reswrap utility and the applications included in the FOX Toolkit"
		einfo "(adie, calculator, pathfinder, shutterbug) are now available as"
		einfo "separate ebuilds."
		echo

		if version_is_at_least "1.7.25"; then
			einfo "Fox versions after 1.7.25 ships a pkg-config file called fox17.pc"
			einfo "instead of the previous fox-config tool."
			einfo "You now get all info via pkg-config:"
			einfo
			einfo "pkg-config fox17 --libs (etc.)"
		else
			einfo "The fox-config script has been installed as fox-${FOXVER}-config."
			einfo "The fox-wrapper package is used to direct calls to fox-config"
			einfo "to the correct versioned script, based on the WANT_FOX variable."
			einfo "For example:"
			einfo
			einfo "    WANT_FOX=\"${FOXVER}\" fox-config <options>"
		fi
		einfo
	fi
}
