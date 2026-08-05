# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.rdoc"
RUBY_FAKEGEM_GEMSPEC="activemodel.gemspec"
RUBY_FAKEGEM_BINWRAP=""

inherit edo ruby-fakegem

DESCRIPTION="Toolkit for building modeling frameworks like Active Record and Active Resource"
HOMEPAGE="https://github.com/rails/rails"

SRC_URI="https://github.com/rails/rails/archive/v${PV}.tar.gz -> rails-${PV}.tgz"
RUBY_S="rails-${PV}/${PN}"

LICENSE="MIT"
SLOT="$(ver_cut 1-2)"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~sparc ~x86"

ruby_add_rdepend "
	~dev-ruby/activesupport-${PV}:*
"

ruby_add_bdepend "
	test? (
		>=dev-ruby/bcrypt-ruby-3.1.11
		dev-ruby/bundler
		dev-ruby/minitest:5
	)
"

all_ruby_prepare() {
	# Replace Gemfile with something simpler for the test run
	cat <<-EOF > ../Gemfile || die
	source "https://rubygems.org"
	gemspec

	gem "rake"

	gem "minitest", "~> 5.0"

	gem "bcrypt", "~> 3.1.11"
	EOF
	rm ../Gemfile.lock || die
}

each_ruby_test() {
	local -x BUNDLE_GEMFILE="../Gemfile"
	local -x MT_NO_PLUGINS=true
	edo ${RUBY} -S bundle exec ${RUBY} --disable=did_you_mean -S rake
}
