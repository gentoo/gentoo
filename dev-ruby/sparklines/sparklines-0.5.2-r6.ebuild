# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY="ruby23 ruby24 ruby25"

RUBY_FAKEGEM_TASK_DOC=""

RUBY_FAKEGEM_EXTRADOC="History.txt README.txt"

inherit ruby-fakegem

DESCRIPTION="Create sparklines, small graphs to be used inline in texts"
HOMEPAGE="http://sparklines.rubyforge.org/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86 ~x86-macos"
IUSE=""

RDEPEND="dev-ruby/rmagick"

ruby_add_bdepend test "dev-ruby/tidy_table dev-ruby/dust"

all_ruby_prepare() {
	# Don't use deprecated rmagick require for compatibility with newer
	# versions.
	sed -i -e '/require/ s/RMagick/rmagick/' lib/sparklines.rb || die
}

each_ruby_test() {
	${RUBY} -I. test/test_all.rb || die
}
