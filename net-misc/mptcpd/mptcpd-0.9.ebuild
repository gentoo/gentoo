# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools linux-info systemd

DESCRIPTION="Daemon that performs multipath TCP path management related operations."
HOMEPAGE="https://github.com/intel/mptcpd/"

LICENSE="GPL-2"
SLOT="0/${PV}"
IUSE="debug doc"

RDEPEND="
	>=dev-libs/ell-0.30.0
	elibc_musl? ( sys-libs/argp-standalone )
	"
DEPEND="
	${RDEPEND}
	>=sys-kernel/linux-headers-5.6
	"
BDEPEND="
	doc? (
		app-doc/doxygen
		app-text/pandoc
	)
	virtual/pkgconfig
	"
PATCHES=(
	"${FILESDIR}/${P}-loopback-monitoring.patch"
)

if [[ ${PV} == 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/intel/mptcpd.git"
else
	SRC_URI="https://github.com/intel/mptcpd/releases/download/v${PV}/${P}.tar.gz"
	KEYWORDS="~amd64"
fi

CONFIG_CHECK="MPTCP"

src_prepare() {
	default
	[[ ${PV} == 9999* ]] && eautoreconf
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
