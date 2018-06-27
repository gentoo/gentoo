# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:  Maya-2018 for amd64$
EAPI="4"

inherit rpm eutils

DESCRIPTION="Autodesk's Maya. Commercial modeling and animation package"
HOMEPAGE="http://usa.autodesk.com/maya/"
SRC_URI="https://edutrial.autodesk.com/NET18SWDLD/2018/MAYA/ESD/Autodesk_Maya_2018_EN_Linux_64bit.tgz"

LICENSE="maya-2018"
SLOT="2018"
KEYWORDS="~amd64"
IUSE="bundled-libs openmotif"

RESTRICT="mirror nouserpriv"

# Needed for install
DEPEND="app-arch/rpm2targz app-arch/tar"

# MayaPy needs at least this to work:
RDEPEND="app-shells/tcsh
	media-libs/libpng:1.2
	dev-lang/python
	x11-libs/libXinerama
	x11-libs/libXrender
	media-libs/fontconfig
	media-libs/glu
	amd64? ( app-emulation/emul-linux-x86-gtklibs )
	virtual/jpeg:62
"

RDEPEND="${RDEPEND}
	=media-gfx/adlmapps-14
	=media-gfx/adlmflexnet-14
"

# The ./setup program needs these two libs to work
RDEPEND="${RDEPEND} x11-libs/libXrandr x11-libs/libXft"


# Stuff I'm not sure about
RDEPEND="${RDEPEND}
	x11-libs/libxcb app-admin/gamin dev-libs/libgamin
	media-libs/libquicktime media-libs/audiofile
	sys-libs/e2fsprogs-libs media-libs/openal
	amd64? (
		!bundled-libs? ( x11-libs/libXpm x11-libs/libXmu x11-libs/libXt x11-libs/libXp x11-libs/libXi x11-libs/libXext x11-libs/libX11 x11-libs/libXau x11-libs/libxcb )
		bundled-libs? ( app-emulation/emul-linux-x86-xlibs app-emulation/emul-linux-x86-baselibs app-emulation/emul-linux-x86-qtlibs )
		openmotif? ( x11-libs/openmotif )
	)"

S="${WORKDIR}"

pkg_nofetch() {
	einfo "This ebuild expects that you place the file ${SRC_URI} in /usr/portage/distfiles"
}

src_unpack() {
	unpack ${A}

	rpm2tar Autodesk_Maya_2018_EN_Linux_64bit.tgz -O | tar -x
	assert "Failed to unpack Autodesk_Maya_2018_EN_Linux_64bit.tgz"
}

src_install() {
	# Copy the unpacked things to to the build directory
	cp -pPR ./usr ./var ./opt ${D} || die

	# Linking party! \:D/
	mkdir -p ${D}usr/lib64/ ${D}usr/lib/
	ln -s libtiff.so    ${D}usr/lib/libtiff.so.3
	ln -s libssl.so     ${D}usr/lib64/libssl.so.6
	ln -s libcrypto.so  ${D}usr/lib64/libcrypto.so.6
	ln -s libGLU.so.1.3 ${D}usr/autodesk/maya2018-x64/lib/libGLU.so.1 # If the systemwide libGLU isn't present, maya has it's own

	mkdir -p ${D}usr/bin/
	ln -s /usr/autodesk/maya2018-x64/bin/maya2012 ${D}usr/bin/maya
	ln -s /usr/autodesk/maya2018-x64/bin/Render   ${D}usr/bin/Render
	ln -s /usr/autodesk/maya2018-x64/bin/fcheck   ${D}usr/bin/fcheck
	ln -s /usr/autodesk/maya2018-x64/bin/imgcvt   ${D}usr/bin/imgcvt

	ln -s maya2018-x64 ${D}usr/autodesk/maya

	# Desktop Icon
	mkdir -p ${D}usr/share/applications/ ${D}usr/share/icons/hicolor/48x48/apps/
	ln -s /usr/autodesk/maya2018-x64/desktop/Autodesk-Maya.desktop ${D}usr/share/applications/Autodesk-Maya.desktop
	ln -s /usr/autodesk/maya2018-x64/desktop/Maya.png              ${D}usr/share/icons/hicolor/48x48/apps/Maya.png

	# Mental Ray needs it's own temporary directory
	mkdir ${D}usr/tmp
	chmod ugo+w ${D}usr/tmp
}

pkg_postinst() {
	einfo "To activate your license you must follow these steps:"
	einfo
	einfo
	einfo "Doublecheck this file: /usr/autodesk/maya2012-x64/bin/License.env"
	einfo " # echo 'MAYA_LICENSE=unlimited'      >  /usr/autodesk/maya2018-x64/bin/License.env"
	einfo " # echo 'MAYA_LICENSE_METHOD=network' >> /usr/autodesk/maya2018-x64/bin/License.env"
	einfo
	einfo
	einfo "And then you need to run this as root to activate your license:"
	einfo " # LD_LIBRARY_PATH=/opt/Autodesk/Adlm/R4/lib64 /usr/autodesk/maya2018-x64/bin/adlmreg -i S 657D1 657D1 2012.0.0.F <your serial number> /var/opt/Autodesk/Adlm/Maya2018/MayaConfig.pit"
	einfo
	einfo
	einfo "If you have a network license you need to do this:"
	einfo " # echo 'SERVER <servername> 0' >  /var/flexlm/maya.lic"
	einfo " # echo 'USE_SERVER'            >> /var/flexlm/maya.lic"
	einfo
	einfo
	einfo "You might need to run the setup as root by hand even after this to make license things work..."
	einfo " # mkdir ~/maya; cd ~/maya; cp /usr/portage/distfiles/Autodesk_Maya_2018_EN_Linux_64bit.tgz .; tar -xf Autodesk_Maya_2018_EN_Linux_64bit.tgz; ./setup; cd ~; rm -rf ~/maya"
	einfo "It *seems to not matter* if the rpm install fails, it alter files somewhere that makes licenses to work. Correct me on this?"
	einfo
	einfo
	einfo "The file: /var/opt/Autodesk/Adlm/.config/ProductInformation.pit shuld be possible to pass around between computers for shared licenses. I don't know what it does."
	einfo "The file: /var/opt/Autodesk/Adlm/Maya2012/install.env seems to be created by the ./setup program and contains the license info, I don't know if that's whats needed to get license running without running ./setup program"
}

pkg_postrm() {
	einfo "Be aware that Maya likes to leave files hanging, like creating totaly unpredicted files"
	einfo "And you know what that means, even now there's crap in your system left there by maya..."
	einfo
	einfo "These directories are probably present in your system:"
	einfo " * /var/opt/Autodesk/"
	einfo
	einfo "And maybe more, who knows?"
}
© 2018 GitHub, Inc.
Terms
Privacy
Security
Status
Help
Contact GitHub
API
Training
Shop
Blog
About
