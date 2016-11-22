# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_RUBY="ruby20"

#RUBY_FAKEGEM_RECIPE_TEST="rspec"

# No documentation task
RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.md CHANGELOG.md ISSUES.md UPGRADING.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="An easy way to vendor gem dependencies"
HOMEPAGE="https://github.com/carlhuda/bundler"
SRC_URI="https://github.com/carlhuda/bundler/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="doc test"

ruby_add_rdepend virtual/rubygems

ruby_add_bdepend "doc? ( app-text/ronn )"

# ruby_add_bdepend "test? ( app-text/ronn )"

# The specs require a number of gems to be installed in a temporary
# directory, but this requires network access. All tests should still
# pass with network access.
RESTRICT="test"

RDEPEND+=" dev-vcs/git"

all_ruby_prepare() {
	# Bundler only supports running the specs from git:
	# https://github.com/carlhuda/bundler/issues/issue/738
	sed -i -e '/when Bundler is bundled/,/^  end/ s:^:#:' spec/runtime/setup_spec.rb || die

	# Fails randomly and no clear cause can be found. Might be related
	# to bug 346357. This was broken in previous releases without a
	# failing spec, so patch out this spec for now since it is not a
	# regression.
	sed -i -e '/works when you bundle exec bundle/,/^  end/ s:^:#:' spec/install/deploy_spec.rb || die

	# Remove unneeded git dependency from gemspec, which we need to use
	# for bug 491826
	sed -i -e '/files/ s:^:#:' ${RUBY_FAKEGEM_GEMSPEC} || die

	# Avoid specs that are not compatible with all rspec versions.
	sed -e '/has no malformed whitespace/,/^  end/ s:^:#:' \
		-e '/uses double-quotes consistently/,/^  end/ s:^:#:' \
		-i spec/quality_spec.rb || die

	# Avoid spec failing with git 2.0.
	sed -i -e '/on releasing/,/^        end/ s:^:#:' spec/bundler/gem_helper_spec.rb || die
}

each_ruby_compile() {
	if use doc ; then
		${RUBY} -S rake man:build
	fi
}
