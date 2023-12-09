# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vim-plugin

DESCRIPTION="vim plugin: interface to Web APIs"
HOMEPAGE="https://github.com/mattn/webapi-vim"
SRC_URI="https://github.com/mattn/${PN}-vim/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-vim-${PV}"

LICENSE="BSD"
KEYWORDS="amd64 x86 ~x64-macos"

RDEPEND="net-misc/curl"

src_compile() { :; }
