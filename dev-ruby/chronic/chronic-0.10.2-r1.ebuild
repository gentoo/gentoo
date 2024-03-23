# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="HISTORY.md README.md"

RUBY_FAKEGEM_GEMSPEC="chronic.gemspec"

inherit ruby-fakegem

DESCRIPTION="Chronic is a natural language date/time parser written in pure Ruby"
HOMEPAGE="https://github.com/mojombo/chronic"
LICENSE="MIT"

KEYWORDS="amd64 ~arm64 ~hppa ppc ppc64 ~sparc x86 ~ppc-macos ~x64-macos ~x64-solaris"
SLOT="0"
IUSE=""

ruby_add_bdepend "test? ( >=dev-ruby/minitest-5 )"

all_ruby_prepare() {
	sed -i -e '/git ls-files/d' chronic.gemspec || die

	sed -i -e 's/MiniTest/Minitest/' test/helper.rb || die
}
