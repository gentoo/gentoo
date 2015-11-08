# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_EXTRADOC="HISTORY.md README.md"

inherit ruby-fakegem

DESCRIPTION="Executable feature scenarios"
HOMEPAGE="https://github.com/aslakhellesoy/cucumber/wikis"
LICENSE="Ruby"

KEYWORDS="~amd64"
SLOT="0"
IUSE="test"

ruby_add_bdepend "
	test? (
		>=dev-ruby/unindent-1.0
	)"

USE_RUBY=${USE_RUBY/ruby22} ruby_add_bdepend "test? ( >=dev-ruby/kramdown-1.4.2 )"

ruby_add_rdepend "
	>=dev-ruby/gherkin3-3.1.0:3
"

each_ruby_prepare() {
	case ${RUBY} in
		*ruby22)
			# Avoid dependency on kramdown so we can add the ruby22
			# target.
			rm -f spec/readme_spec.rb || die
			;;
	esac
}
