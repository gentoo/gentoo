# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="Compare doms and assert certain elements exists in doms using Nokogiri"
HOMEPAGE="https://github.com/kaspth/rails-dom-testing"

LICENSE="MIT"
SLOT="2"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86"

ruby_add_rdepend "
	>=dev-ruby/activesupport-5.0.0:*
	>=dev-ruby/nokogiri-1.6
	dev-ruby/minitest:5
"

all_ruby_prepare() {
	cat <<-EOF > "${T}/Gemfile" || die
	gem "minitest", "~> 5"
	gem "nokogiri"
	gem "activesupport"
	EOF
}

each_ruby_test() {
	BUNDLE_GEMFILE="${T}/Gemfile" MT_NO_PLUGINS=1 ${RUBY} -S bundle exec ${RUBY} -Ilib:test:. -e 'Dir["test/*_test.rb"].each{|f| require f}' || die
}
