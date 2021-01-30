# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit python-r1

COMMIT_HASH="f0ba10547cf79c645c9f8382c1626868bc90588a"
DESCRIPTION="Tools for creating recordings of console sessions"
HOMEPAGE="https://github.com/dcoles/asciicast-tools"
SRC_URI="https://github.com/dcoles/${PN}/archive/${COMMIT_HASH}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT_HASH}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	${PYTHON_DEPS}
	app-misc/tmux
"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

src_install() {
	default

	python_foreach_impl python_doscript ${PN%-tools}-pipe
	dobin tmux-${PN%-tools}-pane
}
