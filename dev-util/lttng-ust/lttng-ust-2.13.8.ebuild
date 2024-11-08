# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Please bump the following packages together:
# dev-util/lttng-modules
# dev-util/lttng-tools
# dev-util/lttng-ust

MY_P="${P/_rc/-rc}"
MY_SLOT="$(ver_cut 1-2)"

DESCRIPTION="Linux Trace Toolkit - UST library"
HOMEPAGE="https://lttng.org"
SRC_URI="https://lttng.org/files/${PN}/${MY_P}.tar.bz2"
S="${WORKDIR}"/${MY_P}

LICENSE="GPL-2"
SLOT="0/${MY_SLOT}"
KEYWORDS="~alpha ~amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv sparc ~x86"
IUSE="examples numa test"
RESTRICT="!test? ( test )"

DEPEND="
	>=dev-libs/userspace-rcu-0.12:=
	numa? ( sys-process/numactl )
"
RDEPEND="${DEPEND}"
BDEPEND="
	virtual/pkgconfig
	test? ( dev-lang/perl )
"

QA_CONFIG_IMPL_DECL_SKIP=(
	pthread_get_name_np # different from pthread_getname_*, not on linux
	pthread_set_name_np # different from pthread_setname_*, not on linux
)

src_configure() {
	local myeconfargs=(
		$(use_enable examples)
		$(use_enable numa)
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default
	find "${ED}" -type f -name '*.la' -delete || die
}
