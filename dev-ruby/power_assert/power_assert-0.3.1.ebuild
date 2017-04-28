# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22 ruby23"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.rdoc"

inherit ruby-fakegem

DESCRIPTION="Shows each value of variables and method calls in the expression"
HOMEPAGE="https://github.com/k-tsj/power_assert"
LICENSE="|| ( Ruby BSD-2 )"

KEYWORDS="alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

SLOT="0"
IUSE=""

ruby_add_bdepend "test? ( dev-ruby/test-unit )"

all_ruby_prepare() {
	sed -i -e '/bundler/d' Rakefile || die
	sed -i -e '1igem "test-unit"' test/helper.rb || die
}
