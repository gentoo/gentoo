# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_6 )

inherit python-single-r1

DESCRIPTION="A set of profiles for the GNU Screen console window manager (app-misc/screen)"
HOMEPAGE="http://byobu.co"
SRC_URI="https://launchpad.net/${PN}/trunk/${PV}/+download/${P/-/_}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="screen"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-libs/newt[${PYTHON_MULTI_USEDEP}]
	')
	screen? ( app-misc/screen )
	!screen? ( app-misc/tmux )"

src_prepare() {
	default

	python_fix_shebang .

	# Set default system backend to screen
	if use screen ; then
		sed -i -e 's/#\(BYOBU_BACKEND\).*/\1="screen"/' etc/byobu/backend || die
	fi
}

src_install() {
	default

	# Create symlinks for backends
	dosym ${PN} /usr/bin/${PN}-screen
	dosym ${PN} /usr/bin/${PN}-tmux

	docompress -x /usr/share/doc/${PN}
}
