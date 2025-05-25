# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GUILE_COMPAT=( 2-2 3-0 )
inherit autotools guile

DESCRIPTION="Library providing access to the SSH protocol for GNU Guile"
HOMEPAGE="https://memory-heap.org/~avp/projects/guile-ssh/
	https://github.com/artyom-poptsov/guile-ssh/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/artyom-poptsov/${PN}.git"
else
	SRC_URI="https://github.com/artyom-poptsov/${PN}/archive/v${PV}.tar.gz
		-> ${P}.tar.gz"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

REQUIRED_USE="${GUILE_REQUIRED_USE}"

RDEPEND="
	${GUILE_DEPS}
	dev-libs/boehm-gc
	dev-libs/libatomic_ops
	net-libs/libssh:0=[server,sftp]
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	virtual/pkgconfig
"

DOCS=( AUTHORS ChangeLog NEWS README THANKS TODO )

PATCHES=(
	"${FILESDIR}/${PN}-0.16.2-tests.patch"
)

src_prepare() {
	guile_src_prepare
	eautoreconf
}

src_configure() {
	my_configure() {
		econf guile_snarf=${GUILESNARF}
	}
	guile_foreach_impl my_configure
}

src_install() {
	guile_src_install

	find "${ED}" -name "*.la" -delete || die
}
