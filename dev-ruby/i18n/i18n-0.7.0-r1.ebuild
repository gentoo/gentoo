# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_RUBY="ruby20 ruby21 ruby22"

RUBY_FAKEGEM_RECIPE_TEST="test"
RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem versionator

DESCRIPTION="Add Internationalization support to your Ruby application"
HOMEPAGE="http://rails-i18n.org/"
SRC_URI="https://github.com/svenfuchs/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="$(get_version_component_range 1-2)"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RUBY_PATCHES=( ${P}-frozen-classes.patch )

ruby_add_bdepend "test? (
	>=dev-ruby/activesupport-3.2 <dev-ruby/activesupport-4.3
	dev-ruby/bundler
	dev-ruby/mocha:0.13
	dev-ruby/test_declarative )"

all_ruby_prepare() {
	# Remove bundler lock files since we cannot depend on specific
	# versions in Gentoo.
	rm gemfiles/*.lock || die
}

each_ruby_test() {
	case ${RUBY} in
		*ruby22)
			versions="4.2"
			;;
		*)
			versions="3.2 4.0 4.1 4.2"
			;;
	esac

	for version in ${versions} ; do
		if has_version "dev-ruby/activesupport:${version}" ; then
			einfo "Running tests with activesupport ${version}"
			BUNDLE_GEMFILE="${S}/gemfiles/Gemfile.rails-${version}.x" ${RUBY} -S bundle exec ${RUBY} -S rake test || die
		fi
	done
}
