# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools linux-info systemd

DESCRIPTION="Daemon that performs multipath TCP path management related operations."
HOMEPAGE="https://github.com/intel/mptcpd/"

LICENSE="GPL-2"
SLOT="0/${PV}"
IUSE="debug doc"

RDEPEND="
	>=dev-libs/ell-0.45.0
	elibc_musl? ( sys-libs/argp-standalone )
	"
DEPEND="
	${RDEPEND}
	>=sys-kernel/linux-headers-5.6
	"
BDEPEND="
	doc? (
		app-text/doxygen
		virtual/pandoc
	)
	virtual/pkgconfig
	"

if [[ ${PV} == 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/intel/mptcpd.git"
else
	SRC_URI="https://github.com/intel/mptcpd/releases/download/v${PV}/${P}.tar.gz"
	KEYWORDS="~amd64"
fi

CONFIG_CHECK="MPTCP"

PATCHES=(
	"${FILESDIR}"/${PN}-0.9-no-werror.patch
)

src_prepare() {
	default

	# For Werror patch
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--with-kernel=upstream
		--with-systemdsystemunitdir="$(systemd_get_systemunitdir)"
		$(use_enable debug)
	)

	econf "${myeconfargs[@]}"
}

src_compile() {
	emake
	use doc && emake doxygen-doc
}

src_test() {
	emake check
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
