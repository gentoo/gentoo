# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Please bump the following packages together:
# dev-util/lttng-modules
# dev-util/lttng-tools
# dev-util/lttng-ust

MY_P="${P/_rc/-rc}"
MY_SLOT="$(ver_cut 1-2)"

DESCRIPTION="Linux Trace Toolkit - next generation"
HOMEPAGE="https://lttng.org"
SRC_URI="https://lttng.org/files/${PN}/${MY_P}.tar.bz2"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0/${MY_SLOT}"
KEYWORDS="~amd64 ~x86"
IUSE="+ust"

DEPEND="
	>=dev-libs/userspace-rcu-0.11.0:=
	dev-libs/popt
	>=dev-libs/libxml2-2.7.6
	ust? ( >=dev-util/lttng-ust-${MY_SLOT}.0:= )
"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

QA_CONFIG_IMPL_DECL_SKIP=(
	pthread_get_name_np # different from pthread_getname_*, not on linux
	pthread_set_name_np # different from pthread_setname_*, not on linux
)

src_configure() {
	econf $(usex ust "" --without-lttng-ust)
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
