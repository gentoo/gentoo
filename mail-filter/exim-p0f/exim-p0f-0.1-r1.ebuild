# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=4
inherit eutils flag-o-matic ltprune

DESCRIPTION="This is p0f version 3 dlfunc library for Exim"
HOMEPAGE="https://dist.epipe.com/exim/"
SRC_URI="https://dist.epipe.com/exim/exim-p0f3-dlfunc-${PV}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="mail-mta/exim[dlfunc]"
RDEPEND=">=net-analyzer/p0f-3.05_beta
	${DEPEND}"
S="${WORKDIR}/exim-p0f3-dlfunc-${PV}"

src_configure() {
	append-cppflags "-I/usr/include/exim -DDLFUNC_IMPL"
	econf
}

src_install() {
	default
	prune_libtool_files --all
}
