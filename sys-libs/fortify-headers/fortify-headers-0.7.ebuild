# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ ${PV} == *9999* ]] ; then
	EGIT_REPO_URI="git://git.2f30.org/fortify-headers"
	inherit git-r3
else
	#SRC_URI="http://git.2f30.org/fortify-headers/snapshot/fortify-headers-${PV}.tar.gz"
	SRC_URI="https://dl.2f30.org/releases/${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~mips ~ppc ~x86"
fi

DESCRIPTION="A standalone implementation of fortify source."
HOMEPAGE="http://git.2f30.org/fortify-headers/"

LICENSE="ISC"
SLOT="0"

src_prepare() {
	sed -i -e 's|^PREFIX = /usr/local|PREFIX = /usr|g' Makefile || die
	default
}

src_install() {
	export DESTDIR="${ED}"
	default
}
