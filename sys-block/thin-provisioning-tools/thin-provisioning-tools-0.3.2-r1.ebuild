# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-block/thin-provisioning-tools/thin-provisioning-tools-0.3.2-r1.ebuild,v 1.9 2015/05/29 05:25:36 jmorgan Exp $

EAPI=5
inherit autotools eutils

DESCRIPTION="A suite of tools for thin provisioning on Linux"
HOMEPAGE="http://github.com/jthornber/thin-provisioning-tools"
EXT=.tar.gz
BASE_A=${P}${EXT}
SRC_URI="http://github.com/jthornber/${PN}/archive/v${PV}${EXT} -> ${BASE_A}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ~ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND="dev-libs/expat"
# || ( ) is a non-future proof workaround for Portage unefficiency wrt #477050
DEPEND="${RDEPEND}
	test? (
		|| ( dev-lang/ruby:2.9 dev-lang/ruby:2.8 dev-lang/ruby:2.7 dev-lang/ruby:2.6 dev-lang/ruby:2.5 dev-lang/ruby:2.4 dev-lang/ruby:2.3 dev-lang/ruby:2.2 dev-lang/ruby:2.1 dev-lang/ruby:2.0 dev-lang/ruby:1.9 dev-lang/ruby:1.8 )
		dev-cpp/gmock
		dev-util/cucumber
		dev-util/aruba
		)
	dev-libs/boost"

src_prepare() {
	epatch "${FILESDIR}"/${P}-Remove-ambiguity-between-boost-uint64_t-and-uint64_t.patch
	epatch_user
	eautoreconf
}

src_configure() {
	econf \
		--prefix="${EPREFIX}"/ \
		--bindir="${EPREFIX}"/sbin \
		--with-optimisation='' \
		$(use_enable test testing)
}

src_install() {
	emake install DESTDIR="${D}" MANDIR=/usr/share/man
	dodoc README.md TODO.org
}

src_test() {
	emake unit-test
}
