# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33 ruby34"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRADOC="README.md CHANGELOG.md"

inherit ruby-fakegem

DESCRIPTION="Use the McIlroy-Hunt LCS algorithm to compute differences"
HOMEPAGE="https://github.com/halostatue/diff-lcs"

LICENSE="|| ( Artistic MIT GPL-2+ )"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"

each_ruby_prepare() {
	# Use the current ruby to test script invocation
	sed -e "/system/ s:ruby:${RUBY}:" \
		-i spec/ldiff_spec.rb || die

	# Skip ldiff specs altogether for now since the fixtures are riddled
	# with encoding and newline issues and ldiff is not the core of this gem.
	rm -f spec/ldiff_spec.rb || die
}
