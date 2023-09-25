# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby27 ruby30 ruby31 ruby32"

RUBY_FAKEGEM_TASK_TEST=""
RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_BINWRAP=""

inherit ruby-fakegem

DESCRIPTION="RSpec support and matchers"
HOMEPAGE="https://rubygems.org/gems/rspectacular"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~hppa ~ppc ~ppc64 ~riscv ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

ruby_add_rdepend ">=dev-ruby/rspec-3.1:3 dev-ruby/fuubar:2"

# Note that shoulda-matchers is an optional RDEPEND as a plugin.
# rspectacular doesn't seem to be actively developed anymore and its only
# reverse dependency passes tests w/o this dep installed, which figures given
# it's a plugin.
USE_RUBY="ruby27 ruby30 ruby31" ruby_add_rdepend "dev-ruby/shoulda-matchers:3"
