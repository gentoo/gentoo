# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils versionator readme.gentoo-r1 fdo-mime gnome2-utils pam systemd vmware-bundle

MY_PN="VMware-Workstation"
MY_PV=$(get_version_component_range 1-3)
PV_MODULES="308.$(get_version_component_range 2-3)"
PV_BUILD=$(get_version_component_range 4)
MY_P="${MY_PN}-${MY_PV}-${PV_BUILD}"

SYSTEMD_UNITS_TAG="gentoo-02"

DESCRIPTION="Emulate a complete PC without the performance overhead of most emulators"
HOMEPAGE="http://www.vmware.com/products/workstation/"
BASE_URI="https://softwareupdate.vmware.com/cds/vmw-desktop/ws/${MY_PV}/${PV_BUILD}/linux/core/"
SRC_URI="
	amd64? ( ${BASE_URI}${MY_P}.x86_64.bundle.tar )
	https://github.com/akhuettel/systemd-vmware/archive/${SYSTEMD_UNITS_TAG}.tar.gz -> vmware-systemd-${SYSTEMD_UNITS_TAG}.tgz
	"

LICENSE="vmware GPL-2 GPL-3"
SLOT="0"
KEYWORDS="-* ~amd64"
IUSE="bundled-libs cups doc ovftool server vix +vmware-tools"
RESTRICT="mirror strip"

BUNDLED_LIBS_DIR=/opt/vmware/lib/vmware/lib

BUNDLED_LIBS="
	libXau.so.6
	libXcomposite.so.1
	libXcursor.so.1
	libXdamage.so.1
	libXdmcp.so.6
	libXfixes.so.3
	libXft.so.2
	libXinerama.so.1
	libXrandr.so.2
	libXrender.so.1
	libaio.so.1
	libatk-1.0.so.0
	libatkmm-1.6.so.1
	libatspi.so.0
	libcairo.so.2
	libcairomm-1.0.so.1
	libcrypto.so.1.0.1
	libcurl.so.4
	libdbus-1.so.3
	libfontconfig.so.1
	libfreetype.so.6
	libfuse.so.2
	libgailutil.so.18
	libgcc_s.so.1
	libgcrypt.so.11
	libgdk-x11-2.0.so.0
	libgdk_pixbuf-2.0.so.0
	libgdkmm-2.4.so.1
	libgio-2.0.so.0
	libgiomm-2.4.so.1
	libglib-2.0.so.0
	libglibmm-2.4.so.1
	libglibmm_generate_extra_defs-2.4.so.1
	libgmodule-2.0.so.0
	libgobject-2.0.so.0
	libgpg-error.so.0
	libgthread-2.0.so.0
	libgtk-x11-2.0.so.0
	libgtkmm-2.4.so.1
	libpango-1.0.so.0
	libpangocairo-1.0.so.0
	libpangoft2-1.0.so.0
	libpangomm-1.4.so.1
	libpangox-1.0.so.0
	libpangoxft-1.0.so.0
	libpcsclite.so.1
	libpixman-1.so.0
	libpng12.so.0
	librsvg-2.so.2
	libsigc-2.0.so.0
	libssl.so.1.0.1
	libstdc++.so.6
	libxml2.so.2
	libz.so.1
"

BUNDLED_LIB_DEPENDS="
	app-accessibility/at-spi2-core
	dev-cpp/atkmm
	dev-cpp/cairomm
	dev-cpp/glibmm:2
	dev-cpp/gtkmm:2.4
	dev-cpp/pangomm
	dev-libs/atk
	dev-libs/glib:2
	dev-libs/libaio
	dev-libs/libgcrypt:11/11
	dev-libs/libgpg-error
	dev-libs/libsigc++:2
	dev-libs/libxml2
	dev-libs/openssl:0
	gnome-base/librsvg:2
	media-libs/fontconfig
	media-libs/freetype
	media-libs/libpng:1.2
	net-misc/curl
	sys-apps/dbus
	sys-apps/pcsc-lite
	sys-fs/fuse
	sys-libs/zlib
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:2
	x11-libs/libXau
	x11-libs/libXcomposite
	x11-libs/libXcursor
	x11-libs/libXdamage
	x11-libs/libXdmcp
	x11-libs/libXfixes
	x11-libs/libXft
	x11-libs/libXinerama
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/pango
	x11-libs/pangox-compat
	x11-libs/pixman
"

# vmware should not use virtual/libc as this is a
# precompiled binary package thats linked to glibc.
RDEPEND="
	app-arch/bzip2
	dev-libs/dbus-glib
	dev-libs/expat
	dev-libs/gmp:0
	dev-libs/icu
	dev-libs/json-c
	dev-libs/libcroco
	dev-libs/libffi
	dev-libs/libgcrypt:0/20
	dev-libs/libtasn1:0/6
	dev-libs/nettle:0/6
	gnome-base/gconf
	gnome-base/libgnome-keyring
	media-gfx/graphite2
	media-libs/alsa-lib
	media-libs/harfbuzz:0/0.9.18
	media-libs/libart_lgpl
	media-libs/libpng:0
	media-libs/libvorbis
	media-libs/mesa
	net-dns/libidn
	net-libs/gnutls
	net-print/cups
	sys-apps/tcp-wrappers
	sys-apps/util-linux
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXi
	x11-libs/libXtst
	x11-libs/libXxf86vm
	x11-libs/libdrm
	x11-libs/libxcb
	x11-libs/libxshmfence
	x11-libs/startup-notification
	x11-libs/xcb-util
	x11-themes/hicolor-icon-theme
	bundled-libs? (
		media-libs/jbigkit:0/2.1
		media-libs/tiff:3
		virtual/jpeg:62
	)
	!bundled-libs? ( ${BUNDLED_LIB_DEPENDS} )
	!app-emulation/vmware-player
"
PDEPEND="~app-emulation/vmware-modules-${PV_MODULES}
	vmware-tools? ( app-emulation/vmware-tools )"
DEPEND=">=dev-util/patchelf-0.9"

S=${WORKDIR}
VM_INSTALL_DIR="/opt/vmware"
VM_DATA_STORE_DIR="/var/lib/vmware/Shared VMs"
VM_HOSTD_USER="root"

QA_PREBUILT="/opt/*"

QA_WX_LOAD="opt/vmware/lib/vmware/tools-upgraders/vmware-tools-upgrader-32 opt/vmware/lib/vmware/bin/vmware-vmx-stats opt/vmware/lib/vmware/bin/vmware-vmx-debug opt/vmware/lib/vmware/bin/vmware-vmx"

src_unpack() {
	default
	local bundle=${MY_P}.x86_64.bundle

	local component; for component in \
		vmware-workstation \
		vmware-player-app \
		vmware-player-setup \
		vmware-vmx \
		vmware-network-editor \
		vmware-network-editor-ui \
		vmware-usbarbitrator \
		vmware-vprobe
	do
		vmware-bundle_extract-bundle-component "${bundle}" "${component}" "${S}"
	done

	if use ovftool; then
		vmware-bundle_extract-bundle-component "${bundle}" vmware-ovftool
	fi

	if use server; then
		vmware-bundle_extract-bundle-component "${bundle}" vmware-workstation-server #"${S}"
	fi

	if use vix; then
		vmware-bundle_extract-bundle-component "${bundle}" vmware-vix-core vmware-vix
		vmware-bundle_extract-bundle-component "${bundle}" vmware-vix-lib-Workstation1200 vmware-vix
	fi
}

clean_bundled_libs() {
	einfo "Removing bundled libraries"
	for libname in ${BUNDLED_LIBS} ; do
		rm -rv "${S}"/lib/lib/${libname} || die "Failed removing bundled ${libname}"
	done

	rm -rv "${S}"/lib/libconf || die "Failed removing bundled gtk conf libs"

	# Among the bundled libs there are libcrypto.so.1.0.1 and libssl.so.1.0.1
	# (needed by libcds.so) which seem to be compiled from openssl-1.0.1h.
	# Upstream real sonames are *so.1.0.0 so it's necessary to fix DT_NEEDED link
	# in libcds.so to be able to use system libs.
	pushd >/dev/null .
	einfo "Patching libcds.so"
	cd "${S}"/lib/lib/libcds.so || die
	patchelf --replace-needed libssl.so.1.0.{1,0} \
	         --replace-needed libcrypto.so.1.0.{1,0} \
	         libcds.so || die
	popd >/dev/null

	# vmware-workstation seems to use a custom version of libgksu2.so, for this reason
	# we leave the bundled version. The libvmware-gksu.so library declares simply DT_NEEDED
	# libgksu2.so.0 but it uses at runtime the bundled version, patch the lib to avoid portage
	# preserve-libs mechanism to be triggered when a system lib is available (but not required)
	pushd >/dev/null .
	einfo "Patching libvmware-gksu.so"
	cd "${S}"/lib/lib/libvmware-gksu.so || die
	patchelf --set-rpath "\$ORIGIN/../libgksu2.so.0" \
	         libvmware-gksu.so || die
	popd >/dev/null
}

src_prepare() {
	rm -f bin/vmware-modconfig
	rm -rf lib/modules/binary
	# Bug 459566
	mv lib/libvmware-netcfg.so lib/lib/

	if use server; then
		rm -f vmware-workstation-server/bin/{openssl,configure-hostd.sh}
	fi

	if ! use bundled-libs ; then
		clean_bundled_libs
	fi

	DOC_CONTENTS="
/etc/env.d is updated during ${PN} installation. Please run:\n
env-update && source /etc/profile\n
Before you can use ${PN}, you must configure a default network setup.
You can do this by running 'emerge --config ${PN}'.\n
To be able to run ${PN} your user must be in the vmware group.\n
You MUST set USE=bundled-libs if you are running gcc-5, otherwise vmware will not start.
"
}

src_install() {
	local major_minor=$(get_version_component_range 1-2 "${PV}")

	# revdep-rebuild entry
	insinto /etc/revdep-rebuild
	echo "SEARCH_DIRS_MASK=\"${VM_INSTALL_DIR}\"" >> ${T}/10${PN}
	doins "${T}"/10${PN}

	# install the binaries
	into "${VM_INSTALL_DIR}"
	dobin bin/*

	# install the libraries
	insinto "${VM_INSTALL_DIR}"/lib/vmware
	doins -r lib/*

	# workaround for hardcoded search paths needed during shared objects loading
	if ! use bundled-libs ; then
		dosym /usr/$(get_libdir)/libglib-2.0.so.0 \
			"${VM_INSTALL_DIR}"/lib/vmware/lib/libglib-2.0.so.0/libglib-2.0.so.0
		# Bug 432918
		dosym /usr/$(get_libdir)/libcrypto.so.1.0.0 \
			"${VM_INSTALL_DIR}"/lib/vmware/lib/libcrypto.so.1.0.1/libcrypto.so.1.0.1
		dosym /usr/$(get_libdir)/libssl.so.1.0.0 \
			"${VM_INSTALL_DIR}"/lib/vmware/lib/libssl.so.1.0.1/libssl.so.1.0.1
	fi

	# install the ancillaries
	insinto /usr
	doins -r share

	if use cups; then
		exeinto $(cups-config --serverbin)/filter
		doexe extras/thnucups

		insinto /etc/cups
		doins -r etc/cups/*
	fi

	if use doc; then
		dodoc doc/*
	fi

	exeinto "${VM_INSTALL_DIR}"/lib/vmware/setup
	doexe vmware-config

	# install vmware workstation server
	if use server; then
		dosbin sbin/*

		cd "${S}"/vmware-workstation-server

		# install binaries
		into "${VM_INSTALL_DIR}"/lib/vmware
		dobin bin/*

		dobin "${FILESDIR}"/configure-hostd.sh

		dobin "${FILESDIR}"/configure-hostd.sh

		# install the libraries
		insinto "${VM_INSTALL_DIR}"/lib/vmware/lib
		doins -r lib/*

		into "${VM_INSTALL_DIR}"
		for tool in vmware-hostd wssc-adminTool ; do
			cat > "${T}/${tool}" <<-EOF
				#!/usr/bin/env bash
				set -e

				. /etc/vmware/bootstrap

				exec "${VM_INSTALL_DIR}/lib/vmware/lib/wrapper-gtk24.sh" \\
					"${VM_INSTALL_DIR}/lib/vmware/lib" \\
					"${VM_INSTALL_DIR}/lib/vmware/bin/${tool}" \\
					"${VM_INSTALL_DIR}/lib/vmware/libconf" "\$@"
			EOF
			dobin "${T}/${tool}"
		done

		insinto "${VM_INSTALL_DIR}"/lib/vmware
		doins -r hostd

		# create the configuration
		insinto /etc/vmware/hostd
		doins -r config/etc/vmware/hostd/*
		doins -r etc/vmware/hostd/*

		insinto /etc/vmware/ssl
		doins etc/vmware/ssl/*

		# pam
		pamd_mimic_system vmware-authd auth account

		# create directory for shared virtual machines.
		keepdir "${VM_DATA_STORE_DIR}"
		keepdir /var/log/vmware
	fi

	# install vmware-vix
	if use vix; then
		cd "${S}"/vmware-vix

		# install the binary
		into "${VM_INSTALL_DIR}"
		dobin bin/*

		# install the libraries
		insinto "${VM_INSTALL_DIR}"/lib/vmware-vix
		doins -r lib/*

		dosym vmware-vix/libvixAllProducts.so "${VM_INSTALL_DIR}"/lib/libbvixAllProducts.so

		# install headers
		insinto /usr/include/vmware-vix
		doins include/*

		if use doc; then
			dohtml -r doc/*
		fi
	fi

	# install ovftool
	if use ovftool; then
		cd "${S}"

		insinto "${VM_INSTALL_DIR}"/lib/vmware-ovftool
		doins -r vmware-ovftool/*

		chmod 0755 "${D}${VM_INSTALL_DIR}"/lib/vmware-ovftool/{ovftool,ovftool.bin}
		dosym "${D}${VM_INSTALL_DIR}"/lib/vmware-ovftool/ovftool "${VM_INSTALL_DIR}"/bin/ovftool
	fi

	# create symlinks for the various tools
	local tool ; for tool in thnuclnt vmware vmplayer{,-daemon} licenseTool vmamqpd \
			vmware-{acetool,enter-serial,gksu,fuseUI,modconfig{,-console},netcfg,tray,zenity} ; do
		dosym appLoader "${VM_INSTALL_DIR}"/lib/vmware/bin/"${tool}"
	done
	dosym "${VM_INSTALL_DIR}"/lib/vmware/bin/vmplayer "${VM_INSTALL_DIR}"/bin/vmplayer
	dosym "${VM_INSTALL_DIR}"/lib/vmware/bin/vmware "${VM_INSTALL_DIR}"/bin/vmware
	dosym "${VM_INSTALL_DIR}"/lib/vmware/icu /etc/vmware/icu

	# fix permissions
	fperms 0755 "${VM_INSTALL_DIR}"/lib/vmware/bin/{appLoader,fusermount,launcher.sh,mkisofs,vmware-remotemks}
	fperms 0755 "${VM_INSTALL_DIR}"/lib/vmware/lib/wrapper-gtk24.sh
	fperms 0755 "${VM_INSTALL_DIR}"/lib/vmware/lib/libgksu2.so.0/gksu-run-helper
	fperms 0755 "${VM_INSTALL_DIR}"/lib/vmware/setup/vmware-config
	fperms 4711 "${VM_INSTALL_DIR}"/bin/vmware-mount
	fperms 4711 "${VM_INSTALL_DIR}"/lib/vmware/bin/vmware-vmx{,-debug,-stats}
	if use server; then
		fperms 0755 "${VM_INSTALL_DIR}"/lib/vmware/bin/{vmware-hostd,wssc-adminTool}
		fperms 4711 "${VM_INSTALL_DIR}"/sbin/vmware-authd
		fperms 1777 "${VM_DATA_STORE_DIR}"
	fi
	if use vix; then
		fperms 0755 "${VM_INSTALL_DIR}"/lib/vmware-vix/setup/vmware-config
	fi

	# create the environment
	local envd="${T}/90vmware"
	cat > "${envd}" <<-EOF
		PATH='${VM_INSTALL_DIR}/bin'
		ROOTPATH='${VM_INSTALL_DIR}/bin'
	EOF
	use bundled-libs && echo 'VMWARE_USE_SHIPPED_LIBS=1' >> "${envd}"

	doenvd "${envd}"

	# create the configuration
	dodir /etc/vmware

	cat > "${D}"/etc/vmware/bootstrap <<-EOF
		BINDIR='${VM_INSTALL_DIR}/bin'
		LIBDIR='${VM_INSTALL_DIR}/lib'
	EOF

	cat > "${D}"/etc/vmware/config <<-EOF
		bindir = "${VM_INSTALL_DIR}/bin"
		libdir = "${VM_INSTALL_DIR}/lib/vmware"
		initscriptdir = "/etc/init.d"
		authd.fullpath = "${VM_INSTALL_DIR}/sbin/vmware-authd"
		gksu.rootMethod = "su"
		VMCI_CONFED = "yes"
		VMBLOCK_CONFED = "yes"
		VSOCK_CONFED = "yes"
		NETWORKING = "yes"
		player.product.version = "${MY_PV}"
		product.buildNumber = "${PV_BUILD}"
		product.version = "${MY_PV}"
		product.name = "VMware Workstation"
		workstation.product.version = "${MY_PV}"
	EOF

	if use vix; then
		cat >> "${D}"/etc/vmware/config <<-EOF
			vmware.fullpath = "${VM_INSTALL_DIR}/bin/vmware"
			vix.libdir = "${VM_INSTALL_DIR}/lib/vmware-vix"
			vix.config.version = "1"
		EOF
	fi

	if use server; then
		cat >> "${D}"/etc/vmware/config <<-EOF
			authd.client.port = "902"
			authd.proxy.nfc = "vmware-hostd:ha-nfc"
			authd.soapserver = "TRUE"
		EOF
	fi

	# install the init.d script
	local initscript="${T}/vmware.rc"
	sed -e "s:@@BINDIR@@:${VM_INSTALL_DIR}/bin:g" \
		"${FILESDIR}/vmware-${major_minor}.rc" > "${initscript}" || die
	newinitd "${initscript}" vmware

	if use server; then
		# install the init.d script
		local initscript="${T}/vmware-workstation-server.rc"
		sed -e "s:@@ETCDIR@@:/etc/vmware:g" \
			-e "s:@@PREFIX@@:${VM_INSTALL_DIR}:g" \
			-e "s:@@BINDIR@@:${VM_INSTALL_DIR}/bin:g" \
			-e "s:@@LIBDIR@@:${VM_INSTALL_DIR}/lib/vmware:g" \
			"${FILESDIR}/vmware-server-${major_minor}.rc" > ${initscript} || die
		newinitd "${initscript}" vmware-workstation-server
	fi

	# fill in variable placeholders
	if use bundled-libs ; then
		sed -e "s:@@LIBCONF_DIR@@:${VM_INSTALL_DIR}/lib/vmware/libconf:g" \
			-i "${D}${VM_INSTALL_DIR}"/lib/vmware/libconf/etc/{gtk-2.0/{gdk-pixbuf.loaders,gtk.immodules},pango/pango{.modules,rc}} || die
	fi
	sed -e "s:@@BINARY@@:${VM_INSTALL_DIR}/bin/vmplayer:g" \
		-e "/^Encoding/d" \
		-i "${D}/usr/share/applications/vmware-player.desktop" || die
	sed -e "s:@@BINARY@@:${VM_INSTALL_DIR}/bin/vmware:g" \
		-e "/^Encoding/d" \
		-i "${D}/usr/share/applications/vmware-workstation.desktop" || die
	sed -e "s:@@BINARY@@:${VM_INSTALL_DIR}/bin/vmware-netcfg:g" \
		-e "/^Encoding/d" \
		-i "${D}/usr/share/applications/vmware-netcfg.desktop" || die

	if use server; then
	# Configuration for vmware-workstation-server
		local hostdUser="${VM_HOSTD_USER:-root}"
		sed -e "/ACEDataUser/s:root:${hostdUser}:g" \
			-i "${D}/etc/vmware/hostd/authorization.xml" || die

		# Shared VMs Path: [standard].
		sed -e "s:##{DS_NAME}##:standard:g" \
			-e "s:##{DS_PATH}##:${VM_DATA_STORE_DIR}:g" \
			-i "${D}/etc/vmware/hostd/datastores.xml" || die

		sed -e "s:##{HTTP_PORT}##:-1:g" \
			-e "s:##{HTTPS_PORT}##:443:g" \
			-e "s:##{PIPE_PREFIX}##:/var/run/vmware/:g" \
			-i "${D}/etc/vmware/hostd/proxy.xml" || die

		# See vmware-workstation-server.py for more details.
		sed -e "s:##{BUILD_CFGDIR}##:/etc/vmware/hostd/:g" \
			-e "s:##{CFGALTDIR}##:/etc/vmware/hostd/:g" \
			-e "s:##{CFGDIR}##:/etc/vmware/:g" \
			-e "s:##{ENABLE_AUTH}##:true:g" \
			-e "s:##{HOSTDMODE}##:ws:g" \
			-e "s:##{HOSTD_CFGDIR}##:/etc/vmware/hostd/:g" \
			-e "s:##{HOSTD_MOCKUP}##:false:g" \
			-e "s:##{LIBDIR}##:${VM_INSTALL_DIR}/lib/vmware:g" \
			-e "s:##{LIBDIR_INSTALLED}##:${VM_INSTALL_DIR}/lib/vmware/:g" \
			-e "s:##{LOGDIR}##:/var/log/vmware/:g" \
			-e "s:##{LOGLEVEL}##:verbose:g" \
			-e "s:##{MOCKUP}##:mockup-host-config.xml:g" \
			-e "s:##{PLUGINDIR}##:./:g" \
			-e "s:##{SHLIB_PREFIX}##:lib:g" \
			-e "s:##{SHLIB_SUFFIX}##:.so:g" \
			-e "s:##{USE_BLKLISTSVC}##:false:g" \
			-e "s:##{USE_CBRCSVC}##:false:g" \
			-e "s:##{USE_CIMSVC}##:false:g" \
			-e "s:##{USE_DIRECTORYSVC}##:false:g" \
			-e "s:##{USE_DIRECTORYSVC_MOCKUP}##:false:g" \
			-e "s:##{USE_DYNAMIC_PLUGIN_LOADING}##:false:g" \
			-e "s:##{USE_DYNAMO}##:false:g" \
			-e "s:##{USE_DYNSVC}##:false:g" \
			-e "s:##{USE_GUESTSVC}##:false:g" \
			-e "s:##{USE_HBRSVC}##:false:g" \
			-e "s:##{USE_HBRSVC_MOCKUP}##:false:g" \
			-e "s:##{USE_HOSTSVC_MOCKUP}##:false:g" \
			-e "s:##{USE_HTTPNFCSVC}##:false:g" \
			-e "s:##{USE_HTTPNFCSVC_MOCKUP}##:false:g" \
			-e "s:##{USE_LICENSESVC_MOCKUP}##:false:g" \
			-e "s:##{USE_NFCSVC}##:true:g" \
			-e "s:##{USE_NFCSVC_MOCKUP}##:false:g" \
			-e "s:##{USE_OVFMGRSVC}##:true:g" \
			-e "s:##{USE_PARTITIONSVC}##:false:g" \
			-e "s:##{USE_SECURESOAP}##:false:g" \
			-e "s:##{USE_SNMPSVC}##:false:g" \
			-e "s:##{USE_SOLO_MOCKUP}##:false:g" \
			-e "s:##{USE_STATSSVC_MOCKUP}##:false:g" \
			-e "s:##{USE_VCSVC_MOCKUP}##:false:g" \
			-e "s:##{USE_VDISKSVC}##:false:g" \
			-e "s:##{USE_VDISKSVC_MOCKUP}##:false:g" \
			-e "s:##{USE_VMSVC_MOCKUP}##:false:g" \
			-e "s:##{VM_INVENTORY}##:vmInventory.xml:g" \
			-e "s:##{VM_RESOURCES}##:vmResources.xml:g" \
			-e "s:##{WEBSERVER_PORT_ENTRY}##::g" \
			-e "s:##{WORKINGDIR}##:./:g" \
			-i "${D}/etc/vmware/hostd/config.xml" || die

		sed -e "s:##{ENV_LOCATION}##:/etc/vmware/hostd/env/:g" \
			-i "${D}/etc/vmware/hostd/environments.xml" || die

		# @@VICLIENT_URL@@=XXX
		sed -e "s:@@AUTHD_PORT@@:902:g" \
			-i "${D}${VM_INSTALL_DIR}/lib/vmware/hostd/docroot/client/clients.xml" || die
	fi

	# install systemd unit files
	systemd_dounit "${WORKDIR}/systemd-vmware-${SYSTEMD_UNITS_TAG}/"*.{service,target}

	readme.gentoo_create_doc
}

pkg_config() {
	"${VM_INSTALL_DIR}"/bin/vmware-networks --postinstall ${PN},old,new
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
	readme.gentoo_print_elog

	ewarn "${P} is using an old version of libgcrypt library which"
	ewarn "is going to be soon removed from portage due to security reasons"
	ewarn "(see https://bugs.gentoo.org/show_bug.cgi?id=541564)."
	ewarn "Until vmware is fixed upstream you're exposed to security issues!"
}

pkg_prerm() {
	einfo "Stopping ${PN} for safe unmerge"
	/etc/init.d/vmware stop
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
}
