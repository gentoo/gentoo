# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby25 ruby26 ruby27"

RUBY_FAKEGEM_EXTRADOC="considerations.txt History.txt README.txt"

inherit ruby-fakegem

DESCRIPTION="Pragmatic application deployment automation, without mercy"
HOMEPAGE="https://github.com/seattlerb/vlad"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

ruby_add_bdepend ">=dev-ruby/hoe-3.13
	test? ( >=dev-ruby/minitest-5.7 )"
ruby_add_rdepend ">=dev-ruby/rake-remote_task-2.3"

all_ruby_prepare() {
	# Keep Isolate from managing the dependencies.
	sed -i -e '/isolate/ s:^:#:' -e '/rubyforge/ s:^:#:' Rakefile || die
}
