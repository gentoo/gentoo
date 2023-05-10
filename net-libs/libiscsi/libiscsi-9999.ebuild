# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/sahlberg/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/sahlberg/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
fi

DESCRIPTION="iscsi client library and utilities"
HOMEPAGE="https://github.com/sahlberg/libiscsi"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
IUSE="rdma test"
# test_9000_compareandwrite.sh failure needs investigation
RESTRICT="!test? ( test ) test"

RDEPEND="
	dev-libs/libgcrypt:=
	rdma? ( sys-cluster/rdma-core )
"
DEPEND="
	${RDEPEND}
	test? ( dev-util/cunit )
"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--enable-manpages \
		$(use_with rdma) \
		--disable-werror \
		$(use_enable test tests)
}

src_test() {
	emake -C tests test
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
