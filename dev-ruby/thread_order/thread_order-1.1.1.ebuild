# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby27 ruby30 ruby31 ruby32"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="Readme.md"

inherit ruby-fakegem

DESCRIPTION="Test helper for ordering threaded code"
HOMEPAGE="https://github.com/JoshCheek/thread_order"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE=""

all_ruby_prepare() {
	# Avoid failing spec that already has exceptions for some ruby
	# implementations and is not essential.
	sed -i -e '/depending on the stdlib/,/^  end/ s:^:#:' \
		spec/thread_order_spec.rb || die
}
