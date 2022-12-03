# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby27 ruby30 ruby31"

RUBY_FAKEGEM_TASK_TEST="MT_NO_PLUGINS=true test:core"

RUBY_FAKEGEM_EXTRADOC="README.md AUTHORS.md CHANGELOG.md"

RUBY_FAKEGEM_GEMSPEC="sinatra.gemspec"

inherit ruby-fakegem

DESCRIPTION="A DSL for quickly creating web applications in Ruby with minimal effort"
HOMEPAGE="http://www.sinatrarb.com/"
SRC_URI="https://github.com/sinatra/sinatra/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE=""

ruby_add_rdepend "
	dev-ruby/mustermann:3
	>=dev-ruby/rack-2.2.4:2.2
	~dev-ruby/rack-protection-${PV}
	dev-ruby/tilt:2"
ruby_add_bdepend "test? ( >=dev-ruby/rack-test-0.5.6 dev-ruby/erubis dev-ruby/builder <dev-ruby/activesupport-7 )"
ruby_add_bdepend "doc? ( dev-ruby/yard )"

all_ruby_prepare() {
	sed -i -e '/active_support\/core_ext\/hash/igem "activesupport", "<7"' test/helper.rb || die
}
