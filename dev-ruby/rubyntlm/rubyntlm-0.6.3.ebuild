# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby26 ruby27 ruby30 ruby31"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

inherit ruby-fakegem

DESCRIPTION="Ruby/NTLM provides message creator and parser for the NTLM authentication"
HOMEPAGE="https://github.com/winrb/rubyntlm"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc64 ~x86"
IUSE=""

all_ruby_prepare() {
	sed -i -e '/simplecov/ s:^:#:' spec/spec_helper.rb || die
}
