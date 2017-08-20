# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools multilib-minimal

MY_P=${PN}-${PV//./_}
DESCRIPTION="Implementation for atomic memory update operations"
HOMEPAGE="https://github.com/ivmai/libatomic_ops/"
SRC_URI="https://github.com/ivmai/${PN}/archive/${MY_P}.tar.gz"

LICENSE="MIT boehm-gc GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

S=${WORKDIR}/${PN}-${MY_P}

PATCHES=( "${FILESDIR}"/${PN}-7.4.0-docs.patch )

src_prepare() {
	default
	eautoreconf
}

multilib_src_configure() {
	ECONF_SOURCE=${S} econf
}
