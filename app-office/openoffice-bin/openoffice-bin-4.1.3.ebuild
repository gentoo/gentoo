# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit eutils fdo-mime gnome2-utils pax-utils prefix rpm multilib

IUSE="gnome java"

BUILDID="9783"
BVER="${PV/_rc*/}-${BUILDID}"
BVER2=4.1.3-${BUILDID}
BASIS="ooobasis4.1"
BASIS2="basis4.1"
NM="openoffice"
NM1="${NM}-brand"
NM2="${NM}4"
NM3="${NM2}.1.3"
FILEPATH="mirror://sourceforge/openofficeorg.mirror"
if [ "${ARCH}" = "amd64" ] ; then
	XARCH="x86_64"
else
	XARCH="i586"
fi
UP="en-US/RPMS"

DESCRIPTION="Apache OpenOffice productivity suite"
HOMEPAGE="https://www.openoffice.org/"
SRC_URI="amd64? ( "${FILEPATH}"/Apache_OpenOffice_${PV}_Linux_x86-64_install-rpm_en-US.tar.gz )
	x86? ( "${FILEPATH}"/Apache_OpenOffice_${PV}_Linux_x86_install-rpm_en-US.tar.gz )"

# TODO: supports ca_XR (Valencian RACV) locale too
LANGS="ast eu bg ca ca_XV zh_CN zh_TW cs da nl en_GB fi fr gd gl de el he hi hu it ja km ko lt nb pl pt_BR pt ru sr sk sl es sv ta th tr vi"

for X in ${LANGS} ; do
	[[ ${X} != "en" ]] && SRC_URI="${SRC_URI} linguas_${X}? (
		amd64? ( "${FILEPATH}"/Apache_OpenOffice_${PV}_Linux_x86-64_langpack-rpm_${X/_/-}.tar.gz )
		x86? ( "${FILEPATH}"/Apache_OpenOffice_${PV}_Linux_x86_langpack-rpm_${X/_/-}.tar.gz ) )"
	IUSE="${IUSE} linguas_${X}"
done

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND="
	!app-office/openoffice
	!prefix? ( sys-libs/glibc )
	app-arch/unzip
	app-arch/zip
	>=dev-lang/perl-5.0
	dev-lang/python:2.7
	>=media-libs/freetype-2.1.10-r2
	sys-libs/ncurses:5/5
	x11-libs/libXaw
	x11-libs/libXinerama"

DEPEND="${RDEPEND}
	sys-apps/findutils"

PDEPEND="java? ( >=virtual/jre-1.5 )"

RESTRICT="strip"

QA_PREBUILT="usr/$(get_libdir)/${NM}/program/*"
QA_TEXTRELS="usr/$(get_libdir)/${NM}/program/libvclplug_genli.so"

S=${WORKDIR}

src_unpack() {

	unpack ${A}

	cp "${FILESDIR}"/{50-${PN},wrapper.in} "${T}"
	eprefixify "${T}"/{50-${PN},wrapper.in}

	for i in base calc core01 core02 core03 core04 core05 core06 core07 draw graphicfilter images impress math ogltrans ooofonts ooolinguistic pyuno ure writer xsltfilter ; do
		rpm_unpack "./${UP}/${NM}-${i}-${BVER}.${XARCH}.rpm"
	done

	rpm_unpack "./${UP}/${NM}-${BVER}.${XARCH}.rpm"

	for j in base calc draw impress math writer; do
		rpm_unpack "./${UP}/${NM1}-${j}-${BVER}.${XARCH}.rpm"
	done

	rpm_unpack "./${UP}/desktop-integration/${NM3}-freedesktop-menus-${BVER2}.noarch.rpm"

	use gnome && rpm_unpack "./${UP}/${NM}-gnome-integration-${BVER}.${XARCH}.rpm"
	use java && rpm_unpack "./${UP}/${NM}-javafilter-${BVER}.${XARCH}.rpm"

	# English support installed by default
	rpm_unpack "./${UP}/${NM}-en-US-${BVER}.${XARCH}.rpm"
	rpm_unpack "./${UP}/${NM1}-en-US-${BVER}.${XARCH}.rpm"
	for s in base calc draw help impress math res writer ; do
		rpm_unpack "./${UP}/${NM}-en-US-${s}-${BVER}.${XARCH}.rpm"
	done

	# Localization
	strip-linguas ${LANGS}
	for l in ${LINGUAS}; do
		m="${l/_/-}"
		if [[ ${m} != "en" ]] ; then
			LANGDIR="${m}/RPMS/"
			rpm_unpack "./${LANGDIR}/${NM}-${m}-${BVER}.${XARCH}.rpm"
			rpm_unpack "./${LANGDIR}/${NM1}-${m}-${BVER}.${XARCH}.rpm"
			for n in base calc draw help impress math res writer; do
				rpm_unpack "./${LANGDIR}/${NM}-${m}-${n}-${BVER}.${XARCH}.rpm"
			done

		fi
	done

}

src_install () {

	INSTDIR="/usr/$(get_libdir)/${NM}"
	dodir ${INSTDIR}
	# mv "${WORKDIR}"/opt/${NM}/* "${ED}${INSTDIR}" || die
	mv "${WORKDIR}"/opt/${NM2}/* "${ED}${INSTDIR}" || die

	#Menu entries, icons and mime-types
	cd "${ED}${INSTDIR}/share/xdg/"
	for desk in base calc draw impress javafilter math printeradmin qstart startcenter writer; do
		if [ "${desk}" = "javafilter" ] ; then
			use java || { rm javafilter.desktop; continue; }
		fi
		mv ${desk}.desktop ${NM}-${desk}.desktop
		sed -i -e "s/${NM2} /ooffice /g" ${NM}-${desk}.desktop || die
		domenu ${NM}-${desk}.desktop
	done
	insinto /usr/share
	doins -r "${WORKDIR}"/usr/share/icons
	doins -r "${WORKDIR}"/usr/share/mime

	# Make sure the permissions are right
	use prefix || fowners -R root:0 /

	# Install wrapper script
	newbin "${T}/wrapper.in" ooffice
	sed -i -e s/LIBDIR/$(get_libdir)/g "${ED}/usr/bin/ooffice" || die

	# Component symlinks
	for app in base calc draw impress math writer; do
		cp "${ED}/usr/bin/ooffice" "${ED}/usr/bin/oo${app}"
		sed -i -e s/soffice/s${app}/ "${ED}/usr/bin/oo${app}" || die
	done

	dosym ${INSTDIR}/program/spadmin /usr/bin/ooffice-printeradmin
	dosym ${INSTDIR}/program/soffice /usr/bin/soffice

	# Non-java weirdness see bug #99366
	use !java && rm -f "${ED}${INSTDIR}/program/javaldx"

	# prevent revdep-rebuild from attempting to rebuild all the time
	insinto /etc/revdep-rebuild && doins "${T}/50-${PN}"

	# remove soffice bin to avoid collision with libreoffice
	rm -rf "${ED}${EPREFIX}/usr/bin/soffice"

}

pkg_preinst() {

	use gnome && gnome2_icon_savelist

}

pkg_postinst() {

	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	use gnome && gnome2_icon_cache_update

	pax-mark -m "${EPREFIX}"/usr/$(get_libdir)/${NM}/program/soffice.bin

}

pkg_postrm() {

	fdo-mime_desktop_database_update
	use gnome && gnome2_icon_cache_update

}
