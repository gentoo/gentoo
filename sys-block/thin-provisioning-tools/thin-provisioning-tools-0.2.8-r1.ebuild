# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools

DESCRIPTION="A suite of tools for thin provisioning on Linux"
HOMEPAGE="https://github.com/jthornber/thin-provisioning-tools"
EXT=.tar.gz
SRC_URI="https://github.com/jthornber/${PN}/archive/v${PV}${EXT} -> ${P}${EXT}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-linux ~x86-linux"
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
