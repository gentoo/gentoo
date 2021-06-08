# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby25 ruby26 ruby27 ruby30"

RUBY_FAKEGEM_EXTRADOC="Releases README.md"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_GEMSPEC="daemons.gemspec"

inherit ruby-fakegem

DESCRIPTION="Wrap existing ruby scripts to be run as a daemon"
HOMEPAGE="https://github.com/thuehlinger/daemons"
SRC_URI="https://github.com/thuehlinger/daemons/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris ~x86-solaris"
IUSE="examples"

all_ruby_prepare() {
	sed -i -e '/\(pry\|simplecov\)/I s:^:#:' spec/spec_helper.rb || die
	sed -i -e 's/git ls-files/find/' ${RUBY_FAKEGEM_GEMSPEC} || die
}

all_ruby_install() {
	all_fakegem_install

	use examples && dodoc -r examples
}
