# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY="ruby22 ruby23 ruby24"

RUBY_FAKEGEM_EXTRADOC="changelog.txt Readme.md"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"

inherit ruby-fakegem

DESCRIPTION="This library reads and writes .netrc files"
HOMEPAGE="https://github.com/geemus/netrc"
LICENSE="MIT"

KEYWORDS="~amd64 ~arm ~x86"
SLOT="0"
IUSE=""

all_ruby_prepare() {
	sed -e '/test_encrypted_roundtrip/,/^  end/ s:^:#:' -i test/test_netrc.rb || die
	sed -re 's#assert_equal\(nil,#assert_nil\(#g' -i test/test_netrc.rb || die
	sed -re 's/ENV\["HOME"\], nil_home = nil_home, ENV\["HOME"\]/ENV["NETRC"], nil_home = nil_home, ENV["HOME"]/g' -i test/test_netrc.rb || die
	sed -re 's/assert_equal File.join[(]Dir.pwd, \x27.netrc\x27/assert_equal File.join(ENV["HOME"], \x27.netrc\x27/g' -i test/test_netrc.rb || die
}

each_ruby_test() {
	${RUBY} -Ilib:. -e "Dir['test/test_*.rb'].each{|f| require f}" || die
}
