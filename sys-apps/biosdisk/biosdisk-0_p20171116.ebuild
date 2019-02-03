# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

PYTHON_COMPAT=( python2_7 )

inherit python-single-r1

EGIT_COMMIT="f534dd22a795dca9c42f44b52f206bf02eadb682"
DESCRIPTION="A script that creates floppy boot images to flash Dell BIOSes"
HOMEPAGE="https://github.com/dell/biosdisk"
SRC_URI="https://github.com/dell/${PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	>=app-text/dos2unix-5.0
	sys-boot/syslinux
	${PYTHON_DEPS}
"

S=${WORKDIR}/${PN}-${EGIT_COMMIT}

src_install() {
	python_fix_shebang blconf

	dosbin biosdisk blconf

	dodoc AUTHORS README README.dosdisk TODO VERSION
	gunzip biosdisk.8.gz || die
	doman biosdisk.8

	insinto /usr/share/biosdisk
	doins dosdisk.img dosdisk{288,8192,20480}.img biosdisk-mkrpm-{fedora,redhat,generic}-template.spec

	insinto /etc
	doins biosdisk.conf
}
