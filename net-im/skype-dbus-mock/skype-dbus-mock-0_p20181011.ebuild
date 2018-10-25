# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6,3_7} )

inherit python-r1

EGIT_COMMIT="3a9e2882ac5c0ad6be3c5cb5c7da008b4cfa51da"
DESCRIPTION="Mocked systemd dbus interface for skype 8.30+"
HOMEPAGE="https://github.com/maelnor/skype-dbus-mock"
SRC_URI="https://github.com/maelnor/${PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND=">=net-im/skypeforlinux-8.30
	dev-python/dbus-python[${PYTHON_USEDEP}]
	!sys-apps/systemd
	!sys-auth/elogind"

S=${WORKDIR}/${PN}-${EGIT_COMMIT}

src_install() {
	newbin skype-dbus-mock.py skype-dbus-mock
	insinto /usr/share/dbus-1/system-services
	doins org.freedesktop.login1.service
	insinto /usr/share/dbus-1/system.d
	doins skype-dbus-mock.conf
}

pkg_postinst() {
	ewarn "Restart dbus service to apply changes"
}
