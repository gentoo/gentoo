# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module

DESCRIPTION="Linux-native \"fake root\" for implementing rootless containers"
HOMEPAGE="https://github.com/rootless-containers/rootlesskit"
SRC_URI="https://github.com/rootless-containers/rootlesskit/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~zmedico/dist/${P}-deps.tar.xz"
LICENSE="Apache-2.0"
LICENSE+=" BSD BSD-2 ISC MIT"
SLOT="0"

KEYWORDS="~amd64"
IUSE="selinux"

RDEPEND="selinux? ( sec-policy/selinux-rootlesskit )"

src_install() {
	local -x BINDIR=${EPREFIX}/usr/bin
	default
}
