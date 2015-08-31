# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

inherit ruby-fakegem

DESCRIPTION="A Javascript code obfuscator"
HOMEPAGE="https://github.com/rapid7/jsobfu"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

ruby_add_rdepend ">=dev-ruby/rkelly-remix-0.0.6:0"

all_ruby_prepare() {
	sed -i -e '/simplecov/ s:^:#:' \
		-e '/config.\(color\|tty\|formatter\)/ s:^:#:' \
		spec/spec_helper.rb || die

	sed -i -e '/rkelly-remix/,/name:/ s/=/~>/' ../metadata || die
}
