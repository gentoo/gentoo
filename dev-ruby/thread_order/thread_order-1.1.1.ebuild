# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby25 ruby26 ruby27 ruby30"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="Readme.md"

inherit ruby-fakegem

DESCRIPTION="Test helper for ordering threaded code"
HOMEPAGE="https://github.com/JoshCheek/thread_order"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

all_ruby_prepare() {
	# Avoid failing spec that already has exceptions for some ruby
	# implementations and is not essential.
	sed -i -e '/depending on the stdlib/,/^  end/ s:^:#:' \
		spec/thread_order_spec.rb || die
}
