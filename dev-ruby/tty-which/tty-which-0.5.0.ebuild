# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_GEMSPEC="tty-which.gemspec"

inherit ruby-fakegem

DESCRIPTION="Platform independent implementation of Unix which command"
HOMEPAGE="https://github.com/piotrmurach/tty-which"
SRC_URI="https://github.com/piotrmurach/tty-which/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~riscv"

all_ruby_prepare() {
	echo '-rspec_helper' > .rspec || die
	sed -i -e 's:_relative ": "./:' ${RUBY_FAKEGEM_GEMSPEC} || die

	# Fix running specs without bundler, fixed upstream
	sed -e 's/receive(:join)$/receive(:join).and_call_original/' \
		-e '96iallow(::File).to receive(:join).and_call_original' \
		-e '115iallow(::File).to receive(:join).and_call_original' \
		-i spec/unit/which_spec.rb || die
	sed -e '5iallow(::File).to receive(:join).and_call_original' \
		-i spec/unit/executable_file_spec.rb || die
}
