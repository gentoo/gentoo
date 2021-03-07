# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby24 ruby25 ruby26"

RUBY_FAKEGEM_EXTRADOC="History.rdoc README.rdoc"

inherit ruby-fakegem

DESCRIPTION="Pre-process CLI arguments expanding directories into their constituent files"
HOMEPAGE="https://github.com/seattlerb/path_expander"
LICENSE="MIT"

KEYWORDS="~amd64 ~x86"
SLOT="1"
IUSE=""

all_ruby_prepare() {
	# Fix tests depending on sort order
	sed -i -e '/test_process_args_dir/,/^  end/ s:^:#:' \
		-e '33 s/$/.sort/' \
		-e '83 s/act/act.sort/' \
		test/test_path_expander.rb || die
}

each_ruby_test() {
	${RUBY} -Ilib:.:test -e 'Dir["test/test_*.rb"].each{|f| require f}' || die
}
