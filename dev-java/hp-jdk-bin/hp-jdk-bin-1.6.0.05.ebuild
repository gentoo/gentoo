# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit java-vm-2 versionator eutils

DESCRIPTION="HP JDK/JRE and Plug-In"
HOMEPAGE="http://www.hp.com/go/java"

LICENSE="HP-JDKJRE6"
SLOT="$(get_version_component_range 1-2)"
KEYWORDS="-* ~hppa-hpux ~ia64-hpux" # ~hppa64-hpux ~ia64w-hpux

IUSE="doc examples nsplugin"

RDEPEND=""
DEPEND=""

JAVA_RELEASE=$(get_after_major_version)
HP_RELEASE_NAME="${JAVA_RELEASE} - Oct 09"
MY_PV=$(delete_all_version_separators ${JAVA_RELEASE})

DOWNLOADPAGE="https://h20392.www2.hp.com/portal/swdepot/try.do?productNumber=JDKJRE${MY_PV}"

RESTRICT="fetch"

PA_JDK_DIST="jdk6_1${MY_PV}_pa.depot"
IA_JDK_DIST="jdk6_1${MY_PV}_ia.depot"

SRC_URI="
	hppa-hpux? ( ${PA_JDK_DIST} )
	ia64-hpux? ( ${IA_JDK_DIST} )
"
#	hppa64-hpux? ( ${PA_JDK_DIST} )
#	ia64w-hpux?  ( ${IA_JDK_DIST} )

S=${WORKDIR}

# not for metadata use:
use hppa-hpux   && JDK_DIST=${PA_JDK_DIST}
use ia64-hpux   && JDK_DIST=${IA_JDK_DIST}
#use hppa64-hpux && JDK_DIST=${PA_JDK_DIST}
#use ia64w-hpux  && JDK_DIST=${IA_JDK_DIST}

pkg_nofetch() {
	einfo "Due to license restrictions, we cannot redistribute or fetch the distfiles."
	einfo "Please visit"
	einfo "    ${DOWNLOADPAGE}"
	einfo "select 'Software specification'"
	use hppa-hpux &&
	einfo "    PA-RISC JDK ${HP_RELEASE_NAME}"
	use ia64-hpux &&
	einfo "    Itanium(R) JDK ${HP_RELEASE_NAME}"
	einfo "follow the download instructions, and store the downloaded file as"
	einfo "    ${DISTDIR}/${JDK_DIST}"
	einfo "Then restart emerge: 'emerge --resume'"
}

src_unpack() {
	local status=() diag=
	einfo "unpacking ${A}"
	# .depot file contains 0444 directory permissions,
	# which disallows tar to unpack files into them,
	# so we have to create the directory tree first.
	tar tvf "${DISTDIR}"/${A} 2>"${T}"/tar.err |
		awk '{ if (substr($1,1,1) == "d") { print $6 } }' |
		xargs mkdir -p .
	status=(${PIPESTATUS[@]})
	[[ ${status[0]} == 0 ]] || cat "${T}"/tar.err >&2
	[[ ${status[0]} == 0 ]] || diag="${diag}${diag:+, }tar list"
	[[ ${status[1]} == 0 ]] || diag="${diag}${diag:+, }filter dirs"
	[[ ${status[2]} == 0 ]] || diag="${diag}${diag:+, }create dirs"
	[[ ${status[@]} == "0 0 0" ]] || die "unpack failed (${diag})"

	# .depot file is plain tar file, but each contained file
	# is gzip'd itself. But they do not have the .gz suffix.
	# We do rename and gunzip in parallel for performance.
	tar xvf "${DISTDIR}"/${A} 2>"${T}"/tar.err |
		(
			echo 'dollar=$$'
			echo '.PHONY: unzip'
			echo 'default: unzip'
			while read f; do
				[[ ${f} == */ ]] && continue # ignore dirs
				[[ ${f} == J* ]] || continue # only for Jre*/ and Jdk*/
				# there is some "opt/java6/demo/applets/Blink/Blink$1.class"
				f=${f//\$/\$\(dollar\)}
				echo ".PHONY: ${f}"
				echo "unzip: ${f}"
				echo "${f}:"
				echo "	@mv '${f}' '${f}.gz'"
				echo "	@gunzip '${f}.gz'"
			done
		) |
		emake -f - unzip
	status=(${PIPESTATUS[@]})
	diag=
	[[ ${status[0]} == 0 ]] || cat "${T}"/tar.err >&2
	[[ ${status[0]} == 0 ]] || diag="${diag}${diag:+, }tar extract"
	[[ ${status[1]} == 0 ]] || diag="${diag}${diag:+, }create makefile for unzip"
	[[ ${status[2]} == 0 ]] || diag="${diag}${diag:+, }make unzip"
	[[ ${status[@]} == "0 0 0" ]] || die "unpack failed (${diag})"
	eend 0
}

depot-arch() {
	use hppa-hpux   && echo PA20
	use ia64-hpux   && echo IPF32
#	use hppa64-hpux && echo PA20W
#	use ia64w-hpux  && echo IPF64
}

src_install() {
	use prefix || local EPREFIX= ED=${D}
	dodir / || die
	cp -pR Jre*/JRE*-{COM,$(depot-arch){,-HS}}/opt "${ED}" || die
	cp -pR Jdk*/JDK*-{COM,$(depot-arch)}/opt       "${ED}" || die
	! use doc      || cp -pR Jre*/JRE*-COM-DOC/opt "${ED}" || die
	! use examples || cp -pR Jdk*/JDK*-DEMO/opt    "${ED}" || die

	mv "${ED}"/opt/java$(get_version_component_range 2) "${ED}"/opt/${P} || die "rename failed"

	if use nsplugin; then
		local plugin="/opt/${P}/jre/plugin/$(get_system_arch)/mozilla/libjavaplugin_oji$(get_libname)"
		install_mozilla_plugin "${plugin}"
	fi

	local desktop_in="${ED}/opt/${P}/jre/plugin/desktop/sun_java.desktop"
	if [[ -f "${desktop_in}" ]]; then
		local desktop_out="${T}/ibm_jdk-${SLOT}.desktop"
		# install control panel for Gnome/KDE
		sed -e "s#\(Name=\)Java#\1Java Control Panel for HP JDK/JRE ${SLOT}#" \
			-e "s#Exec=.*#Exec=${EPREFIX}/opt/${P}/jre/bin/jcontrol#" \
			-e "s#Icon=.*#Icon=${EPREFIX}/opt/${P}/jre/plugin/desktop/sun_java.png#" \
			"${desktop_in}" > \
			"${desktop_out}" || die

		domenu "${desktop_out}" || die
	fi

	set_java_env
	java-vm_revdep-mask
}
