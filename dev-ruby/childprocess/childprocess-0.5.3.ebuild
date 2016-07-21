# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20"

RUBY_FAKEGEM_RECIPE_TEST="rspec"

RUBY_FAKEGEM_TASK_DOC="yard"
RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="Solution for controlling external programs running in the background"
HOMEPAGE="https://github.com/jarib/childprocess"

LICENSE="MIT"
SLOT="2"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sparc x86"
IUSE=""

ruby_add_bdepend "doc? ( dev-ruby/yard dev-ruby/rspec:2 )"

ruby_add_rdepend "virtual/ruby-ffi"

all_ruby_prepare() {
	# Remove bundler support
	rm Gemfile || die
	sed -i -e "/[Bb]undler/d" Rakefile || die
	sed -i -e "/[Cc]overalls/d" spec/spec_helper.rb || die
	sed -i -e '/git ls-files/d' ${RUBY_FAKEGEM_GEMSPEC} || die
}
