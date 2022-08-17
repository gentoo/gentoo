# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby26 ruby27 ruby30 ruby31"

RUBY_FAKEGEM_TASK_DOC=""

RUBY_FAKEGEM_EXTRADOC="History.txt README.txt"

inherit ruby-fakegem

DESCRIPTION="Create sparklines, small graphs to be used inline in texts"
HOMEPAGE="http://sparklines.rubyforge.org/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND+="test? ( media-gfx/imagemagick[png] )"

ruby_add_rdepend "dev-ruby/rmagick:*"

ruby_add_bdepend "test? ( dev-ruby/tidy_table dev-ruby/dust )"

all_ruby_prepare() {
	# Don't use deprecated rmagick require for compatibility with newer
	# versions.
	sed -i -e '/require/ s/RMagick/rmagick/' lib/sparklines.rb || die
}

each_ruby_test() {
	${RUBY} -I. test/test_all.rb || die
}
