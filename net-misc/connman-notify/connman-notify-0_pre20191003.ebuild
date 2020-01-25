# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{6,7,8} )

inherit desktop python-single-r1 vcs-snapshot

MY_COMMIT="4f1e0a6b27ebf5d9b7508594188fe0f86c34ec52"

DESCRIPTION="Desktop notification integration for connman"
HOMEPAGE="https://gitlab.com/wavexx/connman-notify/"
SRC_URI="https://gitlab.com/wavexx/connman-notify/repository/${MY_COMMIT}/archive.tar.bz2 -> ${P}.tar.bz2"

EGIT_REPO_URI="https://gitlab.com/wavexx/connman-notify.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	net-misc/connman
	virtual/notification-daemon"

src_install() {
	python_fix_shebang ${PN}
	dobin ${PN}
	dodoc README.rst

	make_desktop_entry ${PN} ${PN} ${PN} Network
}
