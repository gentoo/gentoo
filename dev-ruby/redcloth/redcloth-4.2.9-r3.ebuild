# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/redcloth/redcloth-4.2.9-r3.ebuild,v 1.1 2015/07/10 06:45:26 graaff Exp $

EAPI=5

USE_RUBY="ruby19 ruby20"

RUBY_FAKEGEM_NAME="RedCloth"

RUBY_FAKEGEM_RECIPE_TEST="rspec"
RUBY_FAKEGEM_TASK_DOC=""

RUBY_FAKEGEM_DOCDIR="doc"

RUBY_FAKEGEM_EXTRADOC="README.rdoc CHANGELOG"

RUBY_FAKEGEM_REQUIRE_PATHS="lib/case_sensitive_require"

inherit ruby-fakegem versionator

DESCRIPTION="A module for using Textile in Ruby"
HOMEPAGE="http://redcloth.org/"

GITHUB_USER=jgarber
SRC_URI="https://github.com/${GITHUB_USER}/redcloth/tarball/v${PV} -> ${RUBY_FAKEGEM_NAME}-git-${PV}.tgz"
RUBY_S="${GITHUB_USER}-${PN}-*"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

DEPEND+=" dev-util/ragel"

ruby_add_bdepend "
	>=dev-ruby/rake-0.8.7
	>=dev-ruby/rake-compiler-0.7.1
	test? ( >=dev-ruby/diff-lcs-1.1.2 )"

pkg_setup() {
	ruby-ng_pkg_setup

	# Export the VERBOSE variable to avoid remapping of stdout and
	# stderr, and that breaks because of bad interactions between
	# echoe, Ruby and Gentoo.
	export VERBOSE=1
}

RUBY_PATCHES=( ${P}-cve-2012-6684.patch )

all_ruby_prepare() {
	sed -i -e '/[Bb]undler/d' Rakefile ${PN}.gemspec || die
	rm tasks/{release,gems,rspec}.rake || die
}

each_ruby_compile() {
	# We cannot run this manually easily, because Ragel re-generation
	# is a mess
	${RUBY} -S rake compile || die "rake compile failed"
}
