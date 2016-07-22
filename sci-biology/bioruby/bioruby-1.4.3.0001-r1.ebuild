# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_RUBY="ruby20 ruby21"

inherit ruby-fakegem

DESCRIPTION="An integrated environment for bioinformatics using the Ruby language"
LICENSE="Ruby"
HOMEPAGE="http://www.bioruby.org/"
SRC_URI="http://www.${PN}.org/archive/${P}.tar.gz"

SLOT="0"
IUSE=""
KEYWORDS="amd64 ~ppc x86"

ruby_add_rdepend "dev-ruby/libxml"

PATCHES=( "${FILESDIR}"/${P}-fix-tests.patch )

each_ruby_configure() {
	${RUBY} setup.rb config || die
}

each_ruby_compile() {
	${RUBY} setup.rb setup || die
}

each_ruby_install() {
	${RUBY} setup.rb install --prefix="${D}" || die
}

each_ruby_test() {
	${RUBY} -rubygems test/runner.rb || die
}
