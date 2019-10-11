# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# TODO
# 1. Track upstream bug --disable-docs does not work.
#    https://sourceforge.net/p/gphoto/bugs/643/

EAPI=6
inherit eutils multilib multilib-minimal udev

DESCRIPTION="Library that implements support for numerous digital cameras"
HOMEPAGE="http://www.gphoto.org/"
SRC_URI="mirror://sourceforge/gphoto/${P}.tar.bz2"

LICENSE="GPL-2"

# FIXME: should we also bump for libgphoto2_port.so soname version?
SLOT="0/6" # libgphoto2.so soname version

KEYWORDS="alpha amd64 arm ~arm64 ~hppa ia64 ppc ppc64 ~s390 ~sparc x86 ~amd64-linux ~x86-linux"
IUSE="doc examples exif gd jpeg nls serial"

# By default, drivers for all supported cameras will be compiled.
# If you want to only compile for specific camera(s), set CAMERAS
# environment to a space-separated list (no commas) of drivers that
# you want to build.
IUSE_CAMERAS="
	adc65 agfa_cl20 aox ax203
	barbie
	canon casio_qv clicksmart310
	digigr8 digita dimagev dimera3500 directory
	enigma13
	fuji
	gsmart300
	hp215
	iclick
	jamcam jd11 jl2005a jl2005c
	kodak_dc120 kodak_dc210 kodak_dc240 kodak_dc3200 kodak_ez200 konica konica_qm150
	largan lg_gsm
	mars mustek
	panasonic_coolshot panasonic_l859 panasonic_dc1000 panasonic_dc1580 pccam300 pccam600 pentax polaroid_pdc320 polaroid_pdc640 polaroid_pdc700 ptp2
	ricoh ricoh_g3
	samsung sierra sipix_blink2 sipix_web2 smal sonix sony_dscf1 sony_dscf55 soundvision spca50x sq905 st2205 stv0674 stv0680 sx330z
	toshiba_pdrm11 topfield tp6801
"

for camera in ${IUSE_CAMERAS}; do
	IUSE="${IUSE} +cameras_${camera}"
done

# libgphoto2 actually links to libltdl
RDEPEND="
	acct-group/plugdev
	>=dev-libs/libxml2-2.9.1-r4:2[${MULTILIB_USEDEP}]
	dev-libs/libltdl:0[${MULTILIB_USEDEP}]
	>=virtual/libusb-1-r1:1[${MULTILIB_USEDEP}]
	cameras_ax203? ( >=media-libs/gd-2.0.35-r4:=[${MULTILIB_USEDEP}] )
	cameras_st2205? ( >=media-libs/gd-2.0.35-r4:=[${MULTILIB_USEDEP}] )
	exif? ( >=media-libs/libexif-0.6.21-r1:=[${MULTILIB_USEDEP}] )
	gd? ( >=media-libs/gd-2.0.35-r4:=[jpeg=,${MULTILIB_USEDEP}] )
	jpeg? ( >=virtual/jpeg-0-r2:0[${MULTILIB_USEDEP}] )
	serial? ( >=dev-libs/lockdev-1.0.3.1.2-r2[${MULTILIB_USEDEP}] )
	!<sys-fs/udev-201
"
DEPEND="${RDEPEND}
	dev-util/gtk-doc-am
	sys-devel/flex
	>=sys-devel/gettext-0.14.1
	>=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}]
	doc? ( app-doc/doxygen )
"

MULTILIB_CHOST_TOOLS=(
	/usr/bin/gphoto2-port-config
	/usr/bin/gphoto2-config
)

pkg_pretend() {
	if ! echo "${USE}" | grep "cameras_" > /dev/null 2>&1; then
		einfo "No camera drivers will be built since you did not specify any."
	fi
}

src_prepare() {
	default

	# Handle examples ourselves
	sed 's/^\(SUBDIRS =.*\)examples\(.*\)$/\1\2/' -i Makefile.am Makefile.in \
		|| die "examples sed failed"

	sed -e 's/sleep 2//' -i configure || die
}

multilib_src_configure() {
	local myconf
	use doc || myconf=( ac_cv_path_DOXYGEN=false )

	# Upstream doesn't default to --enable-option-checking due having another
	# configure in libgphoto2_port/ that also needs to be checked on every bump
	#
	# Serial port uses either lockdev or ttylock, but we don't have ttylock
	# --with-doc-dir needed to prevent duplicate docs installation, bug #586842
	ECONF_SOURCE=${S} \
	econf \
		--with-doc-dir="${EPREFIX}"/usr/share/doc/${PF} \
		--disable-docs \
		--disable-gp2ddb \
		$(use_enable nls) \
		$(use_with exif libexif auto) \
		$(use_with gd) \
		$(use_with jpeg) \
		$(use_enable serial) \
		$(use_enable serial lockdev) \
		--with-libusb=no \
		--with-libusb-1.0=auto \
		--disable-ttylock \
		--with-camlibs=${cameras} \
		--with-hotplug-doc-dir="${EPREFIX}"/usr/share/doc/${PF}/hotplug \
		--with-rpmbuild=$(type -P true) \
		udevscriptdir="$(get_udevdir)" \
		"${myconf[@]}"
}

src_configure() {
	local cameras
	local cam
	local cam_warn=no
	for cam in ${IUSE_CAMERAS} ; do
		if use "cameras_${cam}"; then
			cameras="${cameras},${cam}"
		else
			cam_warn=yes
		fi
	done

	if [ "${cam_warn}" = "yes" ]; then
		[ -z "${cameras}" ] || cameras="${cameras:1}"
		einfo "Enabled camera drivers: ${cameras:-none}"
		einfo "Upstream will not support you if you do not compile all camera drivers first"
	else
		cameras="all"
		einfo "Enabled camera drivers: all"
	fi

	multilib-minimal_src_configure
}

multilib_src_compile() {
	default

	if multilib_is_native_abi && use doc; then
		doxygen doc/Doxyfile || die "Documentation generation failed"
	fi
}

multilib_src_install_all() {
	prune_libtool_files --modules

	einstalldocs
	dodoc TESTERS MAINTAINERS HACKING

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins examples/README examples/*.c examples/*.h
	fi

	# FIXME: fixup autoconf bug #????
	if ! use doc && [ -d "${ED}/usr/share/doc/${PF}/apidocs.html" ]; then
		rm -fr "${ED}/usr/share/doc/${PF}/apidocs.html"
	fi
	# end fixup

	local udev_rules cam_list
	udev_rules="$(get_udevdir)/rules.d/70-libgphoto2.rules"
	cam_list="/usr/$(get_libdir)/libgphoto2/print-camera-list"

	if [ -x "${ED}"${cam_list} ]; then
		# Let print-camera-list find libgphoto2.so
		export LD_LIBRARY_PATH="${ED}/usr/$(get_libdir)"
		# Let libgphoto2 find its camera-modules
		export CAMLIBS="${ED}/usr/$(get_libdir)/libgphoto2/${PV}"

		einfo "Generating UDEV-rules ..."
		mkdir -p "${ED}"/${udev_rules%/*}
		echo -e "# do not edit this file, it will be overwritten on update\n#" \
			> "${ED}"/${udev_rules}
		"${ED}"${cam_list} udev-rules version 201 group plugdev >> "${ED}"/${udev_rules} \
			|| die "failed to create udev-rules"
	else
		eerror "Unable to find print-camera-list"
		eerror "and therefore unable to generate hotplug usermap."
		eerror "You will have to manually generate it by running:"
		eerror " ${cam_list} udev-rules version 201 group plugdev > ${udev_rules}"
	fi

}

pkg_postinst() {
	if ! has_version "sys-auth/consolekit[acl]" && ! has_version "sys-apps/systemd[acl]" && ! has_version "sys-auth/elogind[acl]" ; then
		elog "Don't forget to add yourself to the plugdev group "
		elog "if you want to be able to access your camera."
	fi

	local old_udev_rules="${EROOT}"etc/udev/rules.d/99-libgphoto2.rules
	if [[ -f ${old_udev_rules} ]]; then
		rm -f "${old_udev_rules}"
	fi
}
