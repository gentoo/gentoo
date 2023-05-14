# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A user-mode PPPoE client and server suite for Linux"
HOMEPAGE="https://dianne.skoll.ca/projects/rp-pppoe/ https://salsa.debian.org/dskoll/rp-pppoe"
if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI=https://github.com/dfskoll/rp-pppoe.git
else
	SRC_URI="https://dianne.skoll.ca/projects/rp-pppoe/download/${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
fi

LICENSE="GPL-2"
SLOT="0"

S="${S}/src"

RDEPEND="
	net-dialup/ppp:=
	sys-apps/iproute2
"
DEPEND=">=sys-kernel/linux-headers-2.6.25
	elibc_musl? ( net-libs/ppp-defs )
	${RDEPEND}"

pkg_setup() {
	# This is needed in multiple phases
	PPPD_VER="$(best_version net-dialup/ppp)"
	PPPD_VER="${PPPD_VER#*/*-}" #reduce it to ${PV}-${PR}
	PPPD_VER="${PPPD_VER%%-*}" #reduce it to ${PV}

	PPPD_PLUGIN_DIR="/usr/$(get_libdir)/pppd/${PPPD_VER}"
}

src_configure() {
	addpredict /dev/ppp

	econf --enable-plugin=/usr/include/pppd
}

src_compile() {
	emake PLUGIN_PATH=rp-pppoe.so PLUGIN_DIR="${PPPD_PLUGIN_DIR}"
}

src_install() {
	emake DESTDIR="${D}" docdir="/usr/share/doc/${PF}" PLUGIN_DIR="${PPPD_PLUGIN_DIR}" install

	# We don't need this README file here.
	rm "${ED}${PPPD_PLUGIN_DIR}/README" || die "Error removing ${PPPD_PLUGIN_DIR}/README from installation"

	newinitd "${FILESDIR}"/pppoe-server.initd pppoe-server
	newconfd "${FILESDIR}"/pppoe-server.confd pppoe-server
}
