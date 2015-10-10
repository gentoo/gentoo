# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="Readme.md"

inherit ruby-fakegem

DESCRIPTION="Test helper for ordering threaded code"
HOMEPAGE="https://github.com/JoshCheek/thread_order"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc64"
IUSE=""

all_ruby_prepare() {
	# Avoid failing spec that already has exceptions for some ruby
	# implementations and is not essential.
	sed -i -e '/depending on the stdlib/,/^  end/ s:^:#:' \
		spec/thread_order_spec.rb || die
}
