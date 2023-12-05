# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby30 ruby31 ruby32"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"
RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="Add Internationalization support to your Ruby application"
HOMEPAGE="http://rails-i18n.org/"
SRC_URI="https://github.com/ruby-i18n/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

ruby_add_rdepend "dev-ruby/concurrent-ruby:1"

ruby_add_bdepend "
	test? (
		>=dev-ruby/activesupport-5.1
		dev-ruby/bundler
		>=dev-ruby/minitest-5.14:5
		dev-ruby/mocha:2
		dev-ruby/test_declarative
	)
"

all_ruby_prepare() {
	rm -f gemfiles/*.lock || die

	# Remove optional unpackaged oj gem
	sed -i -e '/oj/ s:^:#:' gemfiles/* || die

	# Update old test dependencies
	sed -i -e '/rake/ s/~>/>=/' -e '/mocha/ s/1.7.0/2.0/' -e '3igem "json"' gemfiles/* || die

	# Use mocha 2 to avoid minitest deprecation issues.
	sed -i -e 's:mocha/setup:mocha/minitest:' test/test_helper.rb || die
}

each_ruby_test() {
	case ${RUBY} in
		*ruby32)
			versions="6.1 7.0"
			;;
		*ruby31)
			versions="6.1 7.0"
			;;
		*ruby30)
			versions="6.0 6.1 7.0"
			;;
	esac

	for version in ${versions} ; do
		if has_version "dev-ruby/activesupport:${version}" ; then
			einfo "Running tests with activesupport ${version}"
			BUNDLE_GEMFILE="${S}/gemfiles/Gemfile.rails-${version}.x" ${RUBY} -S bundle exec ${RUBY} -S rake test || die
		fi
	done
}
