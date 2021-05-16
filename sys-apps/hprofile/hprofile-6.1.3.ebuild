# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Utility to manage hardware, network, power or other profiles (fork)"
HOMEPAGE="https://github.com/tokiclover/hprofile"
SRC_URI="https://github.com/tokiclover/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_prepare() {
	default
	sed -i '1s:.*:#!/sbin/openrc-run:' hprofile.initd || die
	sed -i "/^prefix/s:=.*:=${EPREFIX}/usr:" Makefile || die
}
