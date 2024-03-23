# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32 ruby33"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_GEMSPEC="ruby-progressbar.gemspec"

inherit ruby-fakegem

DESCRIPTION="A Text Progress Bar Library for Ruby"
HOMEPAGE="https://github.com/jfelchner/ruby-progressbar"
SRC_URI="https://github.com/jfelchner/ruby-progressbar/archive/releases/v${PV}.tar.gz -> ${P}.tar.gz"
RUBY_S="ruby-progressbar-releases-v${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~riscv ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

ruby_add_bdepend "test? ( dev-ruby/timecop )"

all_ruby_prepare() {
	sed -e '/warning_filter/ s:^:#:' \
		-e '/rspectacular/arequire "ruby-progressbar"; require "timecop"' \
		-e '/rspectacular/ s:^:#:' \
		-i spec/spec_helper.rb || die
}
