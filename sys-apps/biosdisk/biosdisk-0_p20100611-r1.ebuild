# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PYTHON_COMPAT=( python2_7 )

inherit versionator python-single-r1

MY_PV=$(get_version_component_range 2)
MY_PV_YEAR=${MY_PV:1:4}
MY_PV_MONTH=${MY_PV:5:2}
MY_PV_DAY=${MY_PV:7:2}
MY_PV="${MY_PV_MONTH}${MY_PV_DAY}${MY_PV_YEAR}"

S=${WORKDIR}/${PN}
DESCRIPTION="A script that creates floppy boot images to flash Dell BIOSes"
HOMEPAGE="http://en.community.dell.com/techcenter/os-applications/w/wiki/linux-projects.aspx"
SRC_URI="http://linux.dell.com/biosdisk/${PN}-git-${MY_PV}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RDEPEND="
	>=app-text/dos2unix-5.0
	sys-boot/syslinux
	${PYTHON_DEPS}
"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

src_install() {
	python_fix_shebang blconf

	dosbin biosdisk blconf

	dodoc AUTHORS README README.dosdisk TODO VERSION
	doman biosdisk.8.gz

	insinto /usr/share/biosdisk
	doins dosdisk.img dosdisk{288,8192}.img biosdisk-mkrpm-{fedora,redhat,generic}-template.spec

	insinto /etc
	doins biosdisk.conf
}
