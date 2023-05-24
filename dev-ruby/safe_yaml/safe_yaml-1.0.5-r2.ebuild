# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Broken with newer psych: https://github.com/dtao/safe_yaml/pull/101
USE_RUBY="ruby27 ruby30"

RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_RECIPE_TEST="none"

inherit ruby-fakegem

DESCRIPTION="Parse YAML safely, alternative implementation of YAML.load"
HOMEPAGE="https://github.com/dtao/safe_yaml"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc x86 ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris"
IUSE="test"

PATCHES=( "${FILESDIR}/${P}-ruby30-arity.patch" "${FILESDIR}/${P}-ruby30-openstruct-tests.patch" )

ruby_add_bdepend "test? ( dev-ruby/hashie
	dev-ruby/heredoc_unindent
	dev-ruby/rspec:3 )"

all_ruby_prepare() {
	sed -i -e '/local timezone/askip "timezone"' spec/transform/to_date_spec.rb || die

	sed -i -e '1igem "psych", "~> 3.0"' spec/spec_helper.rb || die
}

each_ruby_test() {
	# Run specs with monkeypatch
	${RUBY} -S rspec-3 spec --tag ~libraries || die

	# Running specs without monkeypatch
	${RUBY} -S rspec-3 spec --tag libraries || die
}
