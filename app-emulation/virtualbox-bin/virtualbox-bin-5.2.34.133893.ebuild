# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit xdg-utils gnome2 pax-utils python-r1 udev unpacker eapi7-ver

MAIN_PV="$(ver_cut 1-3)"
if [[ ${PV} = *_beta* ]] || [[ ${PV} = *_rc* ]] ; then
	MY_PV="${MAIN_PV}_$(ver_cut 5)"
	MY_PV="${MY_PV/beta/BETA}"
	MY_PV="${MY_PV/rc/RC}"
else
	MY_PV="${MAIN_PV}"
fi
VBOX_BUILD_ID="$(ver_cut 4)"
VBOX_PV="${MY_PV}-${VBOX_BUILD_ID}"
MY_P="VirtualBox-${VBOX_PV}-Linux"
# needed as sometimes the extpack gets another build ID
EXTP_PV="${VBOX_PV}"
EXTP_PN="Oracle_VM_VirtualBox_Extension_Pack"
EXTP_P="${EXTP_PN}-${EXTP_PV}"
# needed as sometimes the SDK gets another build ID
SDK_PV="${VBOX_PV}"
SDK_P="VirtualBoxSDK-${SDK_PV}"

DESCRIPTION="Family of powerful x86 virtualization products for enterprise and home use"
HOMEPAGE="https://www.virtualbox.org/"
SRC_URI="amd64? ( https://download.virtualbox.org/virtualbox/${MY_PV}/${MY_P}_amd64.run )
	x86? ( https://download.virtualbox.org/virtualbox/${MY_PV}/${MY_P}_x86.run )
	https://download.virtualbox.org/virtualbox/${MY_PV}/${EXTP_P}.vbox-extpack -> ${EXTP_P}.tar.gz"

LICENSE="GPL-2 PUEL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+additions +chm headless python vboxwebsrv rdesktop-vrdp"
RESTRICT="bindist mirror"

if [[ "${PV}" != *beta* ]] ; then
	SRC_URI+="
		sdk? ( https://download.virtualbox.org/virtualbox/${MY_PV}/${SDK_P}.zip )"
	IUSE+=" sdk"
fi

DEPEND="app-arch/unzip
	${PYTHON_DEPS}"

RDEPEND="!!app-emulation/virtualbox
	!app-emulation/virtualbox-additions
	~app-emulation/virtualbox-modules-${MAIN_PV}
	!headless? (
		dev-libs/glib
		media-libs/fontconfig
		media-libs/freetype
		media-libs/libpng
		media-libs/libsdl[X]
		x11-libs/libXcursor
		x11-libs/libXext
		x11-libs/libXfixes
		x11-libs/libXft
		x11-libs/libXi
		x11-libs/libXinerama
		x11-libs/libXrandr
		x11-libs/libXrender
		chm? ( dev-libs/expat )
	)
	dev-libs/libxml2
	sys-fs/lvm2
	x11-libs/libXau
	x11-libs/libX11
	x11-libs/libXt
	x11-libs/libXmu
	x11-libs/libSM
	x11-libs/libICE
	x11-libs/libXdmcp
	${PYTHON_DEPS}"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"
S="${WORKDIR}"

QA_PREBUILT="opt/VirtualBox/*"

PYTHON_UPDATER_IGNORE="1"

src_unpack() {
	unpack_makeself ${MY_P}_${ARCH}.run
	unpack ./VirtualBox.tar.bz2

	mkdir "${S}"/${EXTP_PN} || die
	pushd "${S}"/${EXTP_PN} &>/dev/null || die
	unpack ${EXTP_P}.tar.gz
	popd &>/dev/null || die

	if [[ "${PV}" != *beta* ]] && use sdk ; then
		unpack VirtualBoxSDK-${SDK_PV}.zip
	fi
}

src_configure() {
	:;
}

src_compile() {
	:;
}

src_install() {
	# create virtualbox configurations files
	insinto /etc/vbox
	newins "${FILESDIR}/${PN}-config" vbox.cfg

	if ! use headless ; then
		newmenu "${FILESDIR}"/${PN}.desktop-2 ${PN}.desktop

		# set up symlinks (bug #572012)
		dosym ../../../../opt/VirtualBox/virtualbox.xml /usr/share/mime/packages/virtualbox.xml

		local size ico icofile
		for size in 16 24 32 48 64 72 96 128 256 ; do
			pushd "${S}"/icons/${size}x${size} &>/dev/null || die
			if [[ -f "virtualbox.png" ]] ; then
				doicon -s ${size} virtualbox.png
			fi
			for ico in hdd ova ovf vbox{,-extpack} vdi vdh vmdk ; do
				icofile="virtualbox-${ico}.png"
				if [[ -f "${icofile}" ]] ; then
					doicon -s ${size} ${icofile}
				fi
			done
			popd &>/dev/null || die
		done
		doicon -s scalable "${S}"/icons/scalable/virtualbox.svg
		insinto /usr/share/pixmaps
		newins "${S}"/icons/48x48/virtualbox.png ${PN}.png
	fi

	pushd "${S}"/${EXTP_PN} &>/dev/null || die
	insinto /opt/VirtualBox/ExtensionPacks/${EXTP_PN}
	doins -r linux.${ARCH}
	doins ExtPack* PXE-Intel.rom
	popd &>/dev/null || die
	rm -rf "${S}"/${EXTP_PN}

	insinto /opt/VirtualBox
	dodir /opt/bin

	doins UserManual.pdf

	if [[ "${PV}" != *beta* ]] && use sdk ; then
		doins -r sdk
	fi

	if use additions; then
		doins -r additions
	fi

	if use vboxwebsrv; then
		doins vboxwebsrv
		fowners root:vboxusers /opt/VirtualBox/vboxwebsrv
		fperms 0750 /opt/VirtualBox/vboxwebsrv
		dosym ../../opt/VirtualBox/VBox.sh /opt/bin/vboxwebsrv
		newinitd "${FILESDIR}"/vboxwebsrv-initd vboxwebsrv
		newconfd "${FILESDIR}"/vboxwebsrv-confd vboxwebsrv
	fi

	if use rdesktop-vrdp; then
		doins rdesktop-vrdp
		doins -r rdesktop-vrdp-keymaps
		fperms 0750 /opt/VirtualBox/rdesktop-vrdp
		dosym ../../opt/VirtualBox/rdesktop-vrdp /opt/bin/rdesktop-vrdp
	fi

	if ! use headless && use chm; then
		doins kchmviewer VirtualBox.chm
		fowners root:vboxusers /opt/VirtualBox/kchmviewer
		fperms 0750 /opt/VirtualBox/kchmviewer
	fi

	# This ebuild / package supports only py2.7.  When py3 comes is unknown.
	# The compile phase makes VBoxPython2_7.so.
	# py3 support would presumably require a binary pre-compiled by py3.
	use python && doins VBoxPython.so VBoxPython2_7.so

	rm -rf src rdesktop* deffiles install* routines.sh runlevel.sh \
		vboxdrv.sh VBox.sh VBox.png vboxnet.sh additions VirtualBox.desktop \
		VirtualBox.tar.bz2 LICENSE VBoxSysInfo.sh rdesktop* vboxwebsrv \
		webtest kchmviewer VirtualBox.chm vbox-create-usb-node.sh \
		90-vbox-usb.fdi uninstall.sh vboxshell.py vboxdrv-pardus.py \
		VBoxPython?_*.so

	if use headless ; then
		rm -rf VBoxSDL VirtualBox VBoxKeyboard.so
	fi

	doins -r *

	# create symlinks for working around unsupported $ORIGIN/.. in VBoxC.so (setuid)
	dosym ../VBoxVMM.so /opt/VirtualBox/components/VBoxVMM.so
	dosym ../VBoxREM.so /opt/VirtualBox/components/VBoxREM.so
	dosym ../VBoxRT.so /opt/VirtualBox/components/VBoxRT.so
	dosym ../VBoxDDU.so /opt/VirtualBox/components/VBoxDDU.so
	dosym ../VBoxXPCOM.so /opt/VirtualBox/components/VBoxXPCOM.so

	local each
	for each in VBox{Manage,SVC,XPCOMIPCD,Tunctl,NetAdpCtl,NetDHCP,NetNAT,TestOGL,ExtPackHelperApp}; do
		fowners root:vboxusers /opt/VirtualBox/${each}
		fperms 0750 /opt/VirtualBox/${each}
		pax-mark -m "${ED%/}"/opt/VirtualBox/${each}
	done
	# VBoxNetAdpCtl and VBoxNetDHCP binaries need to be suid root in any case..
	fperms 4750 /opt/VirtualBox/VBoxNetAdpCtl
	fperms 4750 /opt/VirtualBox/VBoxNetDHCP
	fperms 4750 /opt/VirtualBox/VBoxNetNAT

	if ! use headless ; then
		# Hardened build: Mark selected binaries set-user-ID-on-execution
		for each in VBox{SDL,Headless} VirtualBox; do
			fowners root:vboxusers /opt/VirtualBox/${each}
			fperms 4510 /opt/VirtualBox/${each}
			pax-mark -m "${ED%/}"/opt/VirtualBox/${each}
		done

		dosym ../VirtualBox/VBox.sh /opt/bin/VirtualBox
		dosym ../VirtualBox/VBox.sh /opt/bin/VBoxSDL
	else
		# Hardened build: Mark selected binaries set-user-ID-on-execution
		fowners root:vboxusers /opt/VirtualBox/VBoxHeadless
		fperms 4510 /opt/VirtualBox/VBoxHeadless
		pax-mark -m "${ED%/}"/opt/VirtualBox/VBoxHeadless
	fi

	exeinto /opt/VirtualBox
	newexe "${FILESDIR}/${PN}-3-wrapper" "VBox.sh"
	fowners root:vboxusers /opt/VirtualBox/VBox.sh
	fperms 0750 /opt/VirtualBox/VBox.sh

	dosym ../VirtualBox/VBox.sh /opt/bin/VBoxManage
	dosym ../VirtualBox/VBox.sh /opt/bin/VBoxVRDP
	dosym ../VirtualBox/VBox.sh /opt/bin/VBoxHeadless
	dosym ../VirtualBox/VBoxTunctl /opt/bin/VBoxTunctl

	# set an env-variable for 3rd party tools
	echo -n "VBOX_APP_HOME=/opt/VirtualBox" > "${T}/90virtualbox"
	doenvd "${T}/90virtualbox"

	local udevdir="$(get_udevdir)"
	insinto ${udevdir}/rules.d
	doins "${FILESDIR}"/10-virtualbox.rules
	sed "s@%UDEVDIR%@${udevdir}@" \
		-i "${ED%/}"${udevdir}/rules.d/10-virtualbox.rules || die
	# move udev scripts into ${udevdir} (bug #372491)
	mv "${ED%/}"/opt/VirtualBox/VBoxCreateUSBNode.sh "${ED%/}"${udevdir} || die
	fperms 0750 ${udevdir}/VBoxCreateUSBNode.sh
}

pkg_postinst() {
	xdg_desktop_database_update

	gnome2_icon_cache_update

	udevadm control --reload-rules && udevadm trigger --subsystem-match=usb

	elog ""
	if ! use headless ; then
		elog "To launch VirtualBox just type: \"VirtualBox\""
		elog ""
	fi
	elog "You must be in the vboxusers group to use VirtualBox."
	elog ""
	elog "For advanced networking setups you should emerge:"
	elog "net-misc/bridge-utils and sys-apps/usermode-utilities"
	elog ""
	elog "Please visit http://www.virtualbox.org/wiki/Editions for"
	elog "an overview about the different features of ${PN}"
	elog "and virtualbox-ose"
	if [ -e "${ROOT}/etc/udev/rules.d/10-virtualbox.rules" ] ; then
		elog ""
		elog "Please remove \"${ROOT}/etc/udev/rules.d/10-virtualbox.rules\""
		elog "or else USB in ${PN} won't work."
	fi
}

pkg_postrm() {
	xdg_desktop_database_update
}
