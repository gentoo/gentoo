# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit vim-plugin

DESCRIPTION="vim plugin: interface to Web APIs"
HOMEPAGE="https://github.com/mattn/webapi-vim"
SRC_URI="https://github.com/mattn/${PN}-vim/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="BSD"
KEYWORDS="amd64 x86 ~x64-macos"

RDEPEND="net-misc/curl"

S="${WORKDIR}/${PN}-vim-${PV}"

src_compile() { :; }
