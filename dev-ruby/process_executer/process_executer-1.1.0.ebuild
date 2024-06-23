# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"
RUBY_FAKEGEM_GEMSPEC="process_executer.gemspec"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"

inherit ruby-fakegem

DESCRIPTION="An API for executing commands in a subprocess"
HOMEPAGE="https://github.com/main-branch/process_executer"
SRC_URI="https://github.com/main-branch/process_executer/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64"

all_ruby_prepare() {
	sed -e '/simplecov/ s:^:#:' \
		-e '/SimpleCov.formatters/,/SimpleCov.start/ s:^:#:' \
		-i spec/spec_helper.rb || die

	sed -e "s:_relative ': './:" \
		-e "s/__dir__/'.'/" \
		-e 's/git ls-files -z/find * -print0/' \
		-i ${RUBY_FAKEGEM_GEMSPEC} || die
}
