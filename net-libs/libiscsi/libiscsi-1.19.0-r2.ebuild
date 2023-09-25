# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/sahlberg/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/sahlberg/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	SRC_URI+=" https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${P}-remove-ld-iscsi.patch.bz2"
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

PATCHES=(
	"${FILESDIR}"/${PN}-1.18.0-fno-common.patch
	"${FILESDIR}"/${PN}-1.18.0-fno-common-2.patch
	"${FILESDIR}"/${PN}-1.18.0-fno-common-3.patch
	"${FILESDIR}"/${PN}-1.19.0-fix-rdma-automagic.patch
	"${WORKDIR}"/${P}-remove-ld-iscsi.patch
)

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
