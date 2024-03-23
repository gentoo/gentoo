# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="Delay the processing"
HOMEPAGE="https://rubygems.org/gems/delayer"

LICENSE="MIT"
SLOT="1"
KEYWORDS="~amd64 ~riscv ~x86"
IUSE=""

all_ruby_prepare() {
	sed -i -e '/bundler/d' Rakefile ${PN}.gemspec test/test_*.rb || die "sed failed"
}
