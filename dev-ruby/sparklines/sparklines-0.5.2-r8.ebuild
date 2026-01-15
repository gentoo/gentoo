# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_TASK_DOC=""

RUBY_FAKEGEM_EXTRADOC="History.txt README.txt"

inherit ruby-fakegem

DESCRIPTION="Create sparklines, small graphs to be used inline in texts"
HOMEPAGE="http://sparklines.rubyforge.org/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

DEPEND+="test? ( media-gfx/imagemagick[png] )"

ruby_add_rdepend "dev-ruby/rmagick:*"

ruby_add_bdepend "test? ( dev-ruby/tidy_table )"

PATCHES=( "${FILESDIR}/${P}-rmagick4-deprecation.patch" )

all_ruby_prepare() {
	# Don't use deprecated rmagick require for compatibility with newer
	# versions.
	sed -i -e '/require/ s/RMagick/rmagick/' lib/sparklines.rb || die

	# Dust does not work with ruby33 and does not seem to be used.
	sed -e '/dust/ s:^:#:' \
		-i test/test_all.rb || die
}

each_ruby_test() {
	${RUBY} -I. test/test_all.rb || die
}
