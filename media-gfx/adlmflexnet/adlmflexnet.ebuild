# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:  adlmflexnet-14 for amd64$
EAPI="4"

inherit rpm eutils

DESCRIPTION="Autodesk License Management Flex Net, Used by Autodesk's Maya. Commercial modeling and animation package"
HOMEPAGE="http://usa.autodesk.com/maya/"
SRC_URI="https://edutrial.autodesk.com/NET18SWDLD/2018/MAYA/ESD/Autodesk_Maya_2018_EN_Linux_64bit.tgz"

LICENSE="maya-2018"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RESTRICT="mirror nouserpriv"

# Needed for install
DEPEND="app-arch/rpm2targz app-arch/tar"

RDEPEND=""

S="${WORKDIR}"

src_unpack() {
	unpack ${A}

	rpm2tar adlmflexnetclient-14.0.23-0.x86_64.rpm -O | tar -x
	assert "Failed to unpack adlmflexnetclient-14.0.23-0.x86_64.rpm"

	rpm2tar adlmflexnetserver-14.0.23-0.x86_64.rpm -O | tar -x
	assert "Failed to unpack adlmflexnetserver-14.0.23-0.x86_64.rpm"
}

src_install() {
	# Copy the unpacked things to to the build directory
	cp -pPR ./opt ${D} || die

	# Flex License Management needs this folder to work
	mkdir -p ${D}var/flexlm/
	chmod ugo+w ${D}var/flexlm/
	touch ${D}var/flexlm/maya.lic
}
