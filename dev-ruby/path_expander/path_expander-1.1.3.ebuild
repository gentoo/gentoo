# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_EXTRADOC="History.rdoc README.rdoc"

inherit ruby-fakegem

DESCRIPTION="Pre-process CLI arguments expanding directories into their constituent files"
HOMEPAGE="https://github.com/seattlerb/path_expander"

LICENSE="MIT"
SLOT="1"
KEYWORDS="~amd64 ~x86"

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
