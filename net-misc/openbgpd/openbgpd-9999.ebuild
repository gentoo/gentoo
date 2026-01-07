# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools git-r3 systemd

DESCRIPTION="OpenBGPD is a free implementation of BGPv4"
HOMEPAGE="http://www.openbgpd.org/"
EGIT_REPO_URI="https://github.com/${PN}-portable/${PN}-portable.git"

LICENSE="ISC"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="
	${DEPEND}
	!!net-misc/quagga
	acct-group/_bgpd
	acct-user/_bgpd
"
BDEPEND="
	dev-util/byacc
	sys-devel/libtool
"

PATCHES=(
	"${FILESDIR}/${P}-update.patch"
	"${FILESDIR}/${P}-config.c.patch"
)

src_unpack() {
	git-r3_src_unpack

	cd "${WORKDIR}"

	EGIT_REPO_URI="https://github.com/openbgpd-portable/openbgpd-openbsd.git"
	EGIT_BRANCH=$(cat "${S}"/OPENBSD_BRANCH)
	EGIT_CHECKOUT_DIR="${S}/openbsd"
	git-r3_fetch
	git-r3_checkout
}

src_prepare() {
	default
	./autogen.sh
	eautoreconf
}

src_configure() {
	export YACC=byacc
	default
}

src_install() {
	default

	newinitd "${FILESDIR}/${PN}-init.d" bgpd
	newconfd "${FILESDIR}/${PN}-conf.d" bgpd
	systemd_newunit "${FILESDIR}/${PN}.service" bgpd.service
}

pkg_postinst() {
	if [ -z "${REPLACING_VERSIONS}" ]; then
		ewarn ""
		ewarn "OpenBGPD portable (not running on OpenBSD) can’t export its RIB"
		ewarn "to the FIB. It’s only suitable for route-reflectors or"
		ewarn "route-servers."
		ewarn ""
	fi
}
