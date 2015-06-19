# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-firewall/shorewall-core/shorewall-core-4.5.21.9.ebuild,v 1.9 2014/11/02 08:52:21 swift Exp $

EAPI="5"

inherit eutils prefix versionator

MY_URL_PREFIX=
case ${P} in
	*_beta* | \
	*_rc*)
		MY_URL_PREFIX='development/'
		;;
esac

MY_PV=${PV/_rc/-RC}
MY_PV=${MY_PV/_beta/-Beta}
MY_P=${PN}-${MY_PV}

MY_MAJOR_RELEASE_NUMBER=$(get_version_component_range 1-2)
MY_MAJORMINOR_RELEASE_NUMBER=$(get_version_component_range 1-3)

DESCRIPTION="Core libraries of shorewall / shorewall(6)-lite"
HOMEPAGE="http://www.shorewall.net/"
SRC_URI="http://www1.shorewall.net/pub/shorewall/${MY_URL_PREFIX}${MY_MAJOR_RELEASE_NUMBER}/shorewall-${MY_MAJORMINOR_RELEASE_NUMBER}/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ppc ppc64 sparc x86"
IUSE="selinux"

DEPEND="
	>=dev-lang/perl-5.10
	virtual/perl-Digest-SHA
	!<net-firewall/shorewall-4.5.0.1
"
RDEPEND="
	${DEPEND}
	>=net-firewall/iptables-1.4.20
	>=sys-apps/iproute2-3.8.0[-minimal]
	>=sys-devel/bc-1.06.95
	>=sys-apps/coreutils-8.20
	selinux? ( >=sec-policy/selinux-shorewall-2.20130424-r2 )
"

DOCS=( changelog.txt releasenotes.txt )

S=${WORKDIR}/${PN}-${MY_PV}

src_prepare() {
	cp "${FILESDIR}"/${PVR}/shorewallrc "${S}"/shorewallrc.gentoo || die "Copying shorewallrc failed"
	eprefixify "${S}"/shorewallrc.gentoo

	epatch_user
}

src_configure() {
	:;
}

src_install() {
	DESTDIR="${D}" ./install.sh shorewallrc.gentoo || die "install.sh failed"
	default
}

pkg_postinst() {
	if ! has_version sys-apps/net-tools; then
		elog "It is recommended to install sys-apps/net-tools which will provide the"
		elog "the 'arp' utility which will give you a better 'shorewall-lite dump' output:"
		elog ""
		elog "  # emerge sys-apps/net-tools"
	fi
}
