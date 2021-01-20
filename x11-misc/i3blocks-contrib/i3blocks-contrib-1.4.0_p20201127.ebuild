# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit vcs-snapshot

COMMIT=154001e5713c26c70063446022919225b6f916f0

DESCRIPTION="A set of scripts for i3blocks, contributed by the community"
HOMEPAGE="https://github.com/vivien/i3blocks-contrib"
SRC_URI="https://github.com/vivien/i3blocks-contrib/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

DEPEND=""
RDEPEND="x11-misc/i3blocks"
BDEPEND=""

src_prepare() {
	sed -i -e '/^$(_BLOCKS):/ s/$/ installdirs/' Makefile
	default
}

src_install() {
	emake DESTDIR="${D}" PREFIX=/usr install
}
