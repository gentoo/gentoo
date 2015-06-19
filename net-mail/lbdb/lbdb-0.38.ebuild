# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/lbdb/lbdb-0.38.ebuild,v 1.5 2012/02/06 18:11:14 ranger Exp $

EAPI=4

inherit versionator eutils

MY_P=${P/-/_}
DESCRIPTION="Little Brother database"
SRC_URI="http://www.spinnaker.de/debian/${MY_P}.tar.gz"
HOMEPAGE="http://www.spinnaker.de/lbdb/"
SLOT="0"
KEYWORDS="amd64 ppc x86"
LICENSE="GPL-2"
IUSE="pda ldap finger nis abook crypt evo"

DEPEND="dev-libs/libvformat
	evo? ( mail-client/evolution )
	finger? ( net-misc/netkit-fingerd )
	abook? ( app-misc/abook )
	crypt? ( app-crypt/gnupg )
	nis? ( net-nds/yp-tools )"
RDEPEND="${DEPEND}
	pda? ( dev-perl/p5-Palm )
	ldap? ( dev-perl/perl-ldap )"

src_configure() {
	local evoversion
	local evolution_addressbook_export

	if use evo ; then
		evoversion=$(best_version mail-client/evolution)
		evoversion=${evoversion##mail-client/evolution-}
		evolution_addressbook_export="/usr/libexec/evolution/$(get_version_component_range 1-2 ${evoversion})/evolution-addressbook-export"
	fi

	econf $(use_with finger) \
		$(use_with abook) \
		$(use_with nis ypcat) \
		$(use_with crypt gpg) \
		$(use_with evo evolution-addressbook-export "${evolution_addressbook_export}" ) \
		--enable-lbdb-dotlock \
		--without-pgp5 --without-pgp \
		--without-niscat --without-addr-email --with-getent \
		--libdir=/usr/$(get_libdir)/lbdb
}

src_install () {
	emake install_prefix="${D}" install
	dodoc README TODO debian/changelog
}
