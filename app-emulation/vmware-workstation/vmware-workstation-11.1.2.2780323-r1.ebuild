# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils versionator readme.gentoo fdo-mime systemd gnome2-utils pam vmware-bundle

MY_PN="VMware-Workstation"
MY_PV=$(get_version_component_range 1-3)
PV_MINOR=$(get_version_component_range 3)
PV_BUILD=$(get_version_component_range 4)
MY_P="${MY_PN}-${MY_PV}-${PV_BUILD}"

SYSTEMD_UNITS_TAG="gentoo-01"

DESCRIPTION="Emulate a complete PC on your PC without the usual performance overhead of most emulators"
HOMEPAGE="http://www.vmware.com/products/workstation/"
BASE_URI="https://softwareupdate.vmware.com/cds/vmw-desktop/ws/${MY_PV}/${PV_BUILD}/linux/core/"
SRC_URI="
	amd64? ( ${BASE_URI}${MY_P}.x86_64.bundle.tar )
	https://github.com/akhuettel/systemd-vmware/archive/${SYSTEMD_UNITS_TAG}.tar.gz
	"
LICENSE="vmware GPL-2"
SLOT="0"
KEYWORDS="-* ~amd64"
IUSE="cups doc ovftool server vix vmware-tools"
RESTRICT="mirror strip"

# vmware-workstation should not use virtual/libc as this is a
# precompiled binary package thats linked to glibc.
RDEPEND="dev-cpp/cairomm
	dev-cpp/glibmm:2
	dev-cpp/gtkmm:2.4
	dev-cpp/libgnomecanvasmm
	dev-cpp/pangomm
	dev-libs/atk
	dev-libs/glib:2
	dev-libs/icu
	dev-libs/expat
	dev-libs/libaio
	=dev-libs/libgcrypt-1.5*
	dev-libs/libsigc++
	dev-libs/libxml2
	dev-libs/openssl:0.9.8
	dev-libs/xmlrpc-c
	gnome-base/libgnomecanvas
	gnome-base/libgtop:2
	gnome-base/librsvg:2
	gnome-base/orbit
	media-libs/fontconfig
	media-libs/freetype
	media-libs/libart_lgpl
	media-libs/libpng:1.2
	media-libs/libpng
	media-libs/tiff:3
	net-misc/curl
	cups? ( net-print/cups )
	sys-devel/gcc
	sys-fs/fuse
	sys-libs/glibc
	sys-libs/zlib
	x11-libs/cairo
	x11-libs/gtk+:2
	x11-libs/libgksu
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libxcb
	x11-libs/libXcomposite
	x11-libs/libXcursor
	x11-libs/libXdamage
	x11-libs/libXdmcp
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXft
	x11-libs/libXi
	x11-libs/libXinerama
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libXtst
	x11-libs/pango
	x11-libs/pangox-compat
	x11-libs/startup-notification
	x11-themes/hicolor-icon-theme
	!app-emulation/vmware-player"
PDEPEND="~app-emulation/vmware-modules-304.${PV_MINOR}
	vmware-tools? ( app-emulation/vmware-tools )"

S=${WORKDIR}
VM_INSTALL_DIR="/opt/vmware"
VM_DATA_STORE_DIR="/var/lib/vmware/Shared VMs"
VM_HOSTD_USER="root"

QA_PREBUILT="/opt/*"

QA_WX_LOAD="opt/vmware/lib/vmware/tools-upgraders/vmware-tools-upgrader-32 opt/vmware/lib/vmware/bin/vmware-vmx-stats opt/vmware/lib/vmware/bin/vmware-vmx-debug opt/vmware/lib/vmware/bin/vmware-vmx"

src_unpack() {
	default
	local bundle
	use amd64 && bundle=${MY_P}.x86_64.bundle
	local component; for component in \
		vmware-vmx \
		vmware-player-app \
		vmware-player-setup \
		vmware-workstation \
		vmware-network-editor \
		vmware-network-editor-ui \
		vmware-usbarbitrator \
		vmware-vprobe
	do
		vmware-bundle_extract-bundle-component "${bundle}" "${component}" "${S}"
	done

	if use server; then
		vmware-bundle_extract-bundle-component "${bundle}" vmware-workstation-server #"${S}"
	fi

	if use vix; then
		vmware-bundle_extract-bundle-component "${bundle}" vmware-vix-core vmware-vix
		vmware-bundle_extract-bundle-component "${bundle}" vmware-vix-lib-Workstation1100andvSphere600 vmware-vix
	fi
	if use ovftool; then
		vmware-bundle_extract-bundle-component "${bundle}" vmware-ovftool
	fi
}

src_prepare() {
	rm -f  bin/vmware-modconfig
	rm -rf lib/modules/binary
	# Bug 459566
	mv lib/libvmware-netcfg.so lib/lib/

	if use server; then
		rm -f vmware-workstation-server/bin/{openssl,configure-hostd.sh}
	fi

	find "${S}" -name '*.a' -delete

#	clean_bundled_libs

	DOC_CONTENTS="
/etc/env.d is updated during ${PN} installation. Please run:\n
env-update && source /etc/profile\n
Before you can use vmware workstation, you must configure a default network setup.
You can do this by running 'emerge --config ${PN}'.\n
To be able to run ${PN} your user must be in the vmware group.
"
}

src_install() {
	local major_minor=$(get_version_component_range 1-2 "${PV}")
	local major_minor_revision=$(get_version_component_range 1-3 "${PV}")
	local build=$(get_version_component_range 4 "${PV}")

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

	# Bug 432918
	dosym "${VM_INSTALL_DIR}"/lib/vmware/lib/libcrypto.so.0.9.8/libcrypto.so.0.9.8 \
		"${VM_INSTALL_DIR}"/lib/vmware/lib/libvmwarebase.so.0/libcrypto.so.0.9.8
	dosym "${VM_INSTALL_DIR}"/lib/vmware/lib/libssl.so.0.9.8/libssl.so.0.9.8 \
		"${VM_INSTALL_DIR}"/lib/vmware/lib/libvmwarebase.so.0/libssl.so.0.9.8

	# install the ancillaries
	insinto /usr
	doins -r share

	if use cups; then
		exeinto $(cups-config --serverbin)/filter
		doexe extras/thnucups

		insinto /etc/cups
		doins -r etc/cups/*
	fi

	insinto /etc/xdg
	doins -r etc/xdg/*

	# install documentation
	doman man/man1/vmware.1.gz

	if use doc; then
		dodoc doc/*
	fi

	insinto "${VM_INSTALL_DIR}"/lib/vmware/setup
	doins vmware-config

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
		for tool in  vmware-{hostd,wssc-adminTool} ; do
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
			vmware-{acetool,enter-serial,gksu,fuseUI,modconfig{,-console},netcfg,tray,unity-helper,zenity} ; do
		dosym appLoader "${VM_INSTALL_DIR}"/lib/vmware/bin/"${tool}"
	done
	dosym "${VM_INSTALL_DIR}"/lib/vmware/bin/vmplayer "${VM_INSTALL_DIR}"/bin/vmplayer
	dosym "${VM_INSTALL_DIR}"/lib/vmware/bin/vmware "${VM_INSTALL_DIR}"/bin/vmware
	dosym "${VM_INSTALL_DIR}"/lib/vmware/icu /etc/vmware/icu

	# fix permissions
	fperms 0755 "${VM_INSTALL_DIR}"/lib/vmware/bin/{appLoader,fusermount,launcher.sh,mkisofs,vmware-remotemks}
	fperms 0755 "${VM_INSTALL_DIR}"/lib/vmware/lib/{wrapper-gtk24.sh,libgksu2.so.0/gksu-run-helper}
	fperms 0755 "${VM_INSTALL_DIR}"/lib/vmware/setup/vmware-config
	fperms 4711 "${VM_INSTALL_DIR}"/bin/vmware-mount
	fperms 4711 "${VM_INSTALL_DIR}"/lib/vmware/bin/vmware-vmx{,-debug,-stats}
	if use server; then
		fperms 0755 "${VM_INSTALL_DIR}"/lib/vmware/bin/vmware-{hostd,wssc-adminTool}
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
		player.product.version = "${major_minor_revision}"
		product.version = "${major_minor_revision}"
		product.buildNumber = "${build}"
		product.name = "VMware Workstation"
		workstation.product.version = "${major_minor_revision}"
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
		"${FILESDIR}/vmware-${major_minor}.rc" > ${initscript}
	newinitd "${initscript}" vmware

	if use server; then
		# install the init.d script
		local initscript="${T}/vmware-workstation-server.rc"
		sed -e "s:@@ETCDIR@@:/etc/vmware:g" \
			-e "s:@@PREFIX@@:${VM_INSTALL_DIR}:g" \
			-e "s:@@BINDIR@@:${VM_INSTALL_DIR}/bin:g" \
			-e "s:@@LIBDIR@@:${VM_INSTALL_DIR}/lib/vmware:g" \
			"${FILESDIR}/vmware-server-${major_minor}.rc" > ${initscript}
		newinitd "${initscript}" vmware-workstation-server
	fi

	# fill in variable placeholders
	sed -e "s:@@LIBCONF_DIR@@:${VM_INSTALL_DIR}/lib/vmware/libconf:g" \
		-i "${D}${VM_INSTALL_DIR}"/lib/vmware/libconf/etc/{gtk-2.0/{gdk-pixbuf.loaders,gtk.immodules},pango/pango{.modules,rc}}
	sed -e "s:@@BINARY@@:${VM_INSTALL_DIR}/bin/vmware:g" \
		-e "/^Encoding/d" \
		-i "${D}/usr/share/applications/${PN}.desktop"
	sed -e "s:@@BINARY@@:${VM_INSTALL_DIR}/bin/vmplayer:g" \
		-e "/^Encoding/d" \
		-i "${D}/usr/share/applications/vmware-player.desktop"
	sed -e "s:@@BINARY@@:${VM_INSTALL_DIR}/bin/vmware-netcfg:g" \
		-e "/^Encoding/d" \
		-i "${D}/usr/share/applications/vmware-netcfg.desktop"

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
	readme.gentoo_pkg_postinst
}

pkg_prerm() {
	einfo "Stopping ${PN} for safe unmerge"
	/etc/init.d/vmware stop
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
}
