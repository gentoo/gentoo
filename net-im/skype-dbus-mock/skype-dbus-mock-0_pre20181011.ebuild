# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
inherit python-single-r1

GIT_COMMIT="3a9e2882ac5c0ad6be3c5cb5c7da008b4cfa51da"
DESCRIPTION="Mocked systemd dbus interface for skype 8.30+"
HOMEPAGE="https://github.com/maelnor/skype-dbus-mock"
S="${WORKDIR}/${PN}-${GIT_COMMIT}"
SRC_URI="https://github.com/maelnor/${PN}/archive/${GIT_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	$(python_gen_cond_dep 'dev-python/dbus-python[${PYTHON_USEDEP}]')
	>=net-im/skypeforlinux-8.30
	!sys-apps/systemd
	!sys-auth/elogind"

src_install() {
	python_doscript skype-dbus-mock.py
	insinto /usr/share/dbus-1/system-services
	doins org.freedesktop.login1.service
	insinto /usr/share/dbus-1/system.d
	doins skype-dbus-mock.conf
}

pkg_postinst() {
	ewarn "Restart dbus service to apply changes"
}
