# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"
RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="Add Internationalization support to your Ruby application"
HOMEPAGE="https://github.com/ruby-i18n/i18n"
SRC_URI="https://github.com/ruby-i18n/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos ~x64-solaris"

ruby_add_rdepend "
	dev-ruby/concurrent-ruby:1
	>=dev-ruby/racc-1.7:0
"

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

	# Remove optional unpackaged oj gem.
	# Make mocha dependency more lenient.
	sed -e '/oj/ s:^:#:' \
		-e '/mocha/ s/2.1.0/2.1/' \
		-i gemfiles/* || die
}

each_ruby_test() {
	case ${RUBY} in
		*ruby34)
			versions="7.2 8.0"
			;;
		*ruby33)
			versions="7.1 7.2 8.0"
			;;
		*ruby32)
			versions="7.1 7.2 8.0"
			;;
	esac

	for version in ${versions} ; do
		if has_version "dev-ruby/activesupport:${version}" ; then
			einfo "Running tests with activesupport ${version}"
			BUNDLE_GEMFILE="${S}/gemfiles/Gemfile.rails-${version}.x" ${RUBY} -S bundle exec ${RUBY} -S rake test || die
		fi
	done
}
