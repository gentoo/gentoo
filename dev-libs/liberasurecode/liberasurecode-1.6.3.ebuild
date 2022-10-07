# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Erasure Code API library written in C with pluggable Erasure Code backends"
HOMEPAGE="https://bitbucket.org/tsg-/liberasurecode/overview"
SRC_URI="https://github.com/openstack/liberasurecode/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
IUSE="doc static-libs"

DEPEND="doc? ( app-doc/doxygen )"

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
	find "${ED}" -name '*.la' -delete || die
}
