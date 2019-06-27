# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools eutils multilib toolchain-funcs

DESCRIPTION="Erasure Code API library written in C with pluggable Erasure Code backends."
HOMEPAGE="https://bitbucket.org/tsg-/liberasurecode/overview"
SRC_URI="https://github.com/openstack/liberasurecode/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
IUSE="doc static-libs"

RDEPEND=""
DEPEND="sys-devel/autoconf
	doc? ( app-doc/doxygen )"

src_prepare() {
	eapply_user
	eautoreconf
}

src_configure() {
	econf \
		--htmldir=/usr/share/doc/${PF} \
		--disable-werror \
		$(use_enable doc doxygen) \
		$(use_enable static-libs static)
}

src_install() {
	default
	prune_libtool_files
}
