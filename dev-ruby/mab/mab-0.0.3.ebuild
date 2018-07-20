# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY="ruby22 ruby23 ruby24 ruby25"

RUBY_FAKEGEM_TASK_TEST="test"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="Markup as Ruby"
HOMEPAGE="https://github.com/camping/mab"
LICENSE="MIT"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"

IUSE="test"

ruby_add_bdepend "
	test? ( >=dev-ruby/minitest-4:0 )"

all_ruby_prepare() {
	sed -i -e '1igem "minitest", "~> 4.0"' test/helper.rb || die
}
