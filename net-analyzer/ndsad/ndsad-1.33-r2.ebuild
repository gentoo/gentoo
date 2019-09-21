# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools

DESCRIPTION="Cisco netflow probe from libpcap, ULOG, tee/divert sources"
HOMEPAGE="https://sourceforge.net/projects/ndsad"
SRC_URI="mirror://sourceforge/ndsad/ndsad-${PV}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

DEPEND="
	>=net-libs/libpcap-0.8
"
RDEPEND="
	${DEPEND}
"
PATCHES=(
	"${FILESDIR}"/${P}-conf_path.patch
	"${FILESDIR}"/${P}-gentoo.patch
	"${FILESDIR}"/${P}-getpid.patch
	"${FILESDIR}"/${P}-log-path.patch
	"${FILESDIR}"/${P}-strncpy-overflow.patch
)
DOCS=( ChangeLog AUTHORS README )

src_prepare() {
	default
	eautoreconf
}

src_install() {
	default

	doman ndsad.conf.5

	insinto /etc
	newins ndsad.conf ndsad.conf

	newinitd "${FILESDIR}"/ndsad.init ndsad
	newconfd "${FILESDIR}"/ndsad.conf.d ndsad
}
