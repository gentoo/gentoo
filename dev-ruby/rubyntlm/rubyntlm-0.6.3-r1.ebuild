# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby27 ruby30 ruby31 ruby32"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

inherit ruby-fakegem

DESCRIPTION="Ruby/NTLM provides message creator and parser for the NTLM authentication"
HOMEPAGE="https://github.com/winrb/rubyntlm"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc64 ~x86"

all_ruby_prepare() {
	sed -i -e '/simplecov/ s:^:#:' spec/spec_helper.rb || die
}
