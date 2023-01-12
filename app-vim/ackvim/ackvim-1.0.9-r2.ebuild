# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vim-plugin

MY_PN="ack.vim"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="vim plugin: run ack from vim"
HOMEPAGE="https://github.com/mileszs/ack.vim"
SRC_URI="https://github.com/mileszs/${MY_PN}/archive/${PV}.tar.gz -> ${MY_P}.tar.gz"
LICENSE="vim"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	|| (
		sys-apps/ack
		sys-apps/the_silver_searcher
	)"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default
	# See bug 584768.
	mv ftplugin/qf.vim ftplugin/ackqf.vim || die
}
