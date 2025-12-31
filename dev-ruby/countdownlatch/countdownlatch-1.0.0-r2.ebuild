# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_TASK_TEST="test"
RUBY_FAKEGEM_TASK_DOC=""

RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="Synchronization aid to allow threads to wait for operations in other threads"
HOMEPAGE="https://github.com/benlangfeld/countdownlatch"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

IUSE="test"

ruby_add_bdepend "test? ( dev-ruby/minitest:5 )"

all_ruby_prepare() {
	sed -i -e '/bundler/ s:^:#:' Rakefile || die

	sed -e '1igem "minitest", "~> 5.0"' \
		-i spec/countdownlatch_spec.rb || die
}
