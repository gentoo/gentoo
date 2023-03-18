# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby27 ruby30 ruby31"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

RUBY_FAKEGEM_TASK_TEST="test:unit"

RUBY_FAKEGEM_GEMSPEC="spring.gemspec"

inherit ruby-fakegem

DESCRIPTION="Rails application preloader"
HOMEPAGE="https://github.com/rails/spring"
SRC_URI="https://github.com/rails/spring/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="1.1"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

IUSE=""

ruby_add_bdepend "test? ( dev-ruby/bundler dev-ruby/activesupport )"

all_ruby_prepare() {
	sed -i -e '/files/d' \
		-e '/bump/d' ${PN}.gemspec || die
	sed -i -e '/bump/d' Rakefile || die
}
