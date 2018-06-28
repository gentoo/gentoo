# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby23 ruby24 ruby25"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"

RUBY_FAKEGEM_EXTRADOC="Changelog.md README.md TODO"

inherit ruby-fakegem eapi7-ver

DESCRIPTION="Highline is a high-level command-line IO library for ruby"
HOMEPAGE="https://github.com/JEG2/highline"
SRC_URI="https://github.com/JEG2/highline/archive/v${PV}.tar.gz -> ${P}.tar.gz"

IUSE=""
LICENSE="|| ( GPL-2 Ruby )"
SLOT="$(ver_cut 1)"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"

all_ruby_prepare() {
	# fix up gemspec file not to call git
	sed -i -e '/git ls-files/d' highline.gemspec || die

	# Avoid unneeded dependencies
	sed -i -e '/\(bundler\|code_statistics\)/ s:^:#:' \
		-e '/PackageTask/,/end/ s:^:#:' Rakefile || die
	sed -i -e '/simplecov/ s:^:#:' test/test_helper.rb || die

	# Remove almost empty doc directory to allow rdoc recipe to work
	rm -rf doc || die
}
