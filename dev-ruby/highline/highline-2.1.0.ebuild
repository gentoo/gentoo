# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby27 ruby30 ruby31 ruby32"

RUBY_FAKEGEM_EXTRADOC="Changelog.md README.md TODO"
RUBY_FAKEGEM_GEMSPEC="highline.gemspec"

inherit ruby-fakegem

DESCRIPTION="Highline is a high-level command-line IO library for ruby"
HOMEPAGE="https://github.com/JEG2/highline"
SRC_URI="https://github.com/JEG2/highline/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="|| ( GPL-2 Ruby-BSD )"
SLOT="$(ver_cut 1)"
KEYWORDS="amd64 ~arm64 ~hppa ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

all_ruby_prepare() {
	# fix up gemspec file not to call git
	sed -i -e 's/git ls-files -z/find * -print0/' highline.gemspec || die

	# Avoid unneeded dependencies
	sed -i -e '/\(bundler\|code_statistics\)/ s:^:#:' \
		-e '/PackageTask/,/end/ s:^:#:' Rakefile || die
	sed -i -e '/simplecov/ s:^:#:' test/test_helper.rb || die

	# Remove almost empty doc directory to allow rdoc recipe to work
	rm -rf doc || die
}
