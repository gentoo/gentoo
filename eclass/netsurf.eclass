# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: netsurf.eclass
# @MAINTAINER:
# Michael Weber <xmw@gentoo.org>
# @BLURB: Handle buildsystem of www.netsurf-browser.org components
# @DESCRIPTION:
# Handle unpacking and usage of separate buildsystem tarball and manage
# multilib build, static-libs generation and debug building.
#
# Supports PATCHES and DOCS as in base.eclass

case ${EAPI:-0} in
	0|1|2|3|4) die "this eclass doesn't support EAPI<5" ;;
	*) ;;
esac

inherit eutils toolchain-funcs multilib-minimal

EXPORT_FUNCTIONS src_prepare src_configure src_compile src_install

# @ECLASS-VARIABLE: NETSURF_BUILDSYSTEM
# @DESCRIPTION:
# Select version of buildsystem tarball to be used along the component
# defaults to buildsystem-1.0
NETSURF_BUILDSYSTEM="${NETSURF_BUILDSYSTEM:-buildsystem-1.0}"

# @ECLASS-VARIABLE: NETSURF_BUILDSYSTEM_SRC_URI
# @DESCRIPTION:
# Download link for NETSURF_BUILDSYSTEM, add to SRC_URI iff set explicitly.
NETSURF_BUILDSYSTEM_SRC_URI="http://download.netsurf-browser.org/libs/releases/${NETSURF_BUILDSYSTEM}.tar.gz -> netsurf-${NETSURF_BUILDSYSTEM}.tar.gz"

# @ECLASS-VARIABLE: NETSURF_COMPONENT_TYPE
# @DESCRIPTION:
# Passed to buildsystem as COMPONENT_TYPE, valid values are
# lib-shared, lib-static and binary. Defaults to "lib-static lib-shared"
NETSURF_COMPONENT_TYPE="${NETSURF_COMPONENT_TYPE:-lib-static lib-shared}"

# @ECLASS-VARIABLE: SRC_URI
# @DESCRIPTION:
# Defaults to http://download.netsurf-browser.org/libs/releases/${P}-src.tar.gz
# and NETSURF_BUILDSYSTEM_SRC_URI.
if [ -z "${SRC_URI}" ] ; then
	SRC_URI="http://download.netsurf-browser.org/libs/releases/${P}-src.tar.gz
	${NETSURF_BUILDSYSTEM_SRC_URI}"
fi

IUSE="debug"
if has lib-static ${NETSURF_COMPONENT_TYPE} ; then
	IUSE+=" static-libs"
fi

DEPEND="virtual/pkgconfig"

# @FUNCTION: netsurf_src_prepare
# @DESCRIPTION:
# Apply and PATCHES and multilib_copy_sources for in-source build.
netsurf_src_prepare() {
	[[ ${PATCHES[@]} ]] && epatch "${PATCHES[@]}"
	debug-print "$FUNCNAME: applying user patches"
	epatch_user

	multilib_copy_sources
}

# @ECLASS-VARIABLE: netsurf_makeconf
# @DESCRIPTION:
# Configuration variable bash array to be passed to emake calls.
# Defined at netsurf_src_configure and can be altered afterwards.

# @FUNCTION: netsurf_src_configure
# @DESCRIPTION:
# Setup netsurf_makeconf and run multilib-minimal_src_configure.
# A default multilib_src_configure is provided by this eclass.
netsurf_src_configure() {
	netsurf_makeconf=(
		NSSHARED=${WORKDIR}/${NETSURF_BUILDSYSTEM}
		Q=
		HOST_CC="\$(CC)"
		CCOPT=
		CCNOOPT=
		CCDBG=
		LDDBG=
		AR="$(tc-getAR)"
		BUILD=$(usex debug debug release)
		PREFIX="${EROOT}"usr
	)

	multilib-minimal_src_configure
}

multilib_src_configure() {
	sed -e "/^INSTALL_ITEMS/s: /lib: /$(get_libdir):g" \
		-i Makefile || die
	if [ -f ${PN}.pc.in ] ; then
		sed -e "/^libdir/s:/lib:/$(get_libdir):g" \
			-i ${PN}.pc.in || die
	fi
	sed -e 's:/bin/which:which:' \
		-i ../${NETSURF_BUILDSYSTEM}/makefiles/Makefile.tools || die
}

# @FUNCTION: netsurf_make
# @DESCRIPTION:
# Calls emake with netsurf_makeconf and toolchain CC/LD
# as arguments for every NETSURF_COMPONENT_TYPE if activated.
netsurf_make() {
	for COMPONENT_TYPE in ${NETSURF_COMPONENT_TYPE} ; do
		if [ "${COMPONENT_TYPE}" == "lib-static" ] ; then
			if ! use static-libs ; then
				continue
			fi
		fi
		emake CC="$(tc-getCC)" LD="$(tc-getLD)" "${netsurf_makeconf[@]}" \
			COMPONENT_TYPE=${COMPONENT_TYPE} LIBDIR="$(get_libdir)" "$@"
	done
}

# @FUNCTION: netsurf_src_compile
# @DESCRIPTION:
# Calls multilib-minimal_src_compile and netsurf_make doc if USE=doc.
# A default multilib_src_compile is provided by this eclass.
netsurf_src_compile() {
	local problems=$(egrep -Hn -- ' (-O.?|-g)( |$)' \
		$(find . -type f -name 'Makefile*'))
	if [ -n "${problems}" ] ; then
		elog "found bad flags:
${problems}"
	fi

	multilib-minimal_src_compile "$@"

	if has doc ${USE} ; then
		netsurf_make "$@" docs
	fi
}

multilib_src_compile() {
	netsurf_make "$@"
}

# @FUNCTION: netsurf_src_test
# @DESCRIPTION:
# Calls multilib-minimal_src_test.
# A default multilib_src_test is provided by this eclass.
netsurf_src_test() {
	multilib-minimal_src_test "$@"
}

multilib_src_test() {
	netsurf_make test "$@"
}

# @FUNCTION: netsurf_src_install
# @DESCRIPTION:
# Calls multilib-minimal_src_install.
# A default multilib_src_test is provided by this eclass.
# A default multilib_src_install is provided by this eclass.
netsurf_src_install() {
	multilib-minimal_src_install "$@"
}

multilib_src_install() {
	#DEFAULT_ABI may not be the last.
	#install to clean dir, rename binaries, move everything back
	if [ "${ABI}" == "${DEFAULT_ABI}" ] ; then
		netsurf_make DESTDIR="${D}" install "$@"
	else
		netsurf_make DESTDIR="${D}"${ABI} install "$@"
		if [ "${ABI}" != "${DEFAULT_ABI}" ] ; then
			find "${D}"${ABI}/usr/bin -type f -exec mv {} {}.${ABI} \;
		fi
		mv "${D}"${ABI}/* "${D}" || die
		rmdir "${D}"${ABI} || die
	fi
}
