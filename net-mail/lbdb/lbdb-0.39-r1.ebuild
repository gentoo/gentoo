# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit versionator

MY_P=${P/-/_}
DESCRIPTION="Little Brother database"
SRC_URI="http://www.spinnaker.de/debian/${MY_P}.tar.gz"
HOMEPAGE="http://www.spinnaker.de/lbdb/"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
LICENSE="GPL-2"
IUSE="pda ldap finger nis abook crypt evo"

DEPEND="dev-libs/libvformat
	evo? ( mail-client/evolution )
	finger? ( net-misc/netkit-fingerd )
	abook? ( app-misc/abook )
	crypt? ( app-crypt/gnupg )"
RDEPEND="${DEPEND}
	pda? ( dev-perl/p5-Palm )
	ldap? ( dev-perl/perl-ldap )"
# Bug 570726
REQUIRED_USE="!nis"

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
		--without-ypcat \
		$(use_with crypt gpg) \
		$(use_with evo evolution-addressbook-export "${evolution_addressbook_export}" ) \
		--enable-lbdb-dotlock \
		--without-pgpk --without-pgp \
		--without-niscat --without-addr-email --with-getent \
		--libdir=/usr/$(get_libdir)/lbdb
}

src_install () {
	emake install_prefix="${D}" install
	dodoc README TODO debian/changelog
}
