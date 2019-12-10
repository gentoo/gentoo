# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P=${P/-/_}
DESCRIPTION="Little Brother database"
HOMEPAGE="https://www.spinnaker.de/lbdb/"
SRC_URI="https://www.spinnaker.de/lbdb/download/${MY_P}.tar.gz"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
LICENSE="GPL-2"
IUSE="abook bbdb crypt evo finger ldap pda test"
RESTRICT="!test? ( test )"

CDEPEND="dev-libs/libvformat
	evo? ( mail-client/evolution )
	finger? ( net-misc/netkit-fingerd )
	abook? ( app-misc/abook )
	crypt? ( app-crypt/gnupg )"
DEPEND="${CDEPEND}
	test? (
		dev-perl/Palm
		dev-perl/perl-ldap
	)"
RDEPEND="${CDEPEND}
	bbdb? ( app-emacs/bbdb )
	pda? ( dev-perl/Palm )
	ldap? ( dev-perl/perl-ldap )"

src_configure() {
	local evoversion
	local evolution_addressbook_export

	if use evo ; then
		evoversion=$(best_version mail-client/evolution)
		evoversion=${evoversion##mail-client/evolution-}
		evolution_addressbook_export="${EPREFIX}/usr/libexec/evolution/$(ver_cut 1-2 ${evoversion})/evolution-addressbook-export"
	fi

	econf $(use_with finger) \
		$(use_with abook) \
		--without-ypcat \
		$(use_with crypt gpg) \
		$(use_with evo evolution-addressbook-export "${evolution_addressbook_export}" ) \
		--enable-lbdb-dotlock \
		--without-pgpk --without-pgp \
		--without-niscat --without-addr-email --with-getent \
		--libdir="${EPREFIX}"/usr/$(get_libdir)/lbdb
}

src_install () {
	emake install_prefix="${D}" install
	dodoc README TODO debian/changelog
}
