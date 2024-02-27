# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/sahlberg/${PN}.git"
	inherit git-r3
else
	if [[ ${PV} == *_p* ]] ; then
		# The S path is too long for the test suite otherwise.
		inherit vcs-snapshot

		MY_COMMIT="22f7b26567760921fa1aad77cca642153123ea8c"
		SRC_URI="https://github.com/sahlberg/libiscsi/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"
	else
		SRC_URI="https://github.com/sahlberg/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	fi

	KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~ia64 ~loong ~ppc ppc64 ~riscv ~sparc x86"
fi

DESCRIPTION="iscsi client library and utilities"
HOMEPAGE="https://github.com/sahlberg/libiscsi"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
IUSE="rdma test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/libgcrypt:=
	rdma? ( sys-cluster/rdma-core )
"
DEPEND="
	${RDEPEND}
	test? ( dev-util/cunit )
"
BDEPEND="
	test? ( >=sys-block/tgt-1.0.58 )
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.19.0_p20230208-fix-rdma-automagic.patch
)

src_prepare() {
	default

	# bug #906063
	rm tests/test_0600_ipv6.sh || die

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
