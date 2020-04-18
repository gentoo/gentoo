# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY="ruby24 ruby25 ruby26"

RUBY_FAKEGEM_TASK_DOC=""

RUBY_FAKEGEM_TASK_TEST="-Ilib test features"

RUBY_FAKEGEM_EXTRAINSTALL="VERSION VERSION_NAME"

inherit ruby-fakegem

DESCRIPTION="Compass Stylesheet Authoring Framework"
HOMEPAGE="http://compass-style.org/"

LICENSE="MIT"
SLOT="1"
KEYWORDS="~amd64"
IUSE=""

# Gem does not contain all files needed to run specs and it is not clear
# which upstream repository/branch/directory to use.
RESTRICT="test"

ruby_add_rdepend ">=dev-ruby/chunky_png-1.2
	>=dev-ruby/compass-core-1.0.2:1.0
	>=dev-ruby/compass-import-once-1.0.5:1.0
	>=dev-ruby/rb-inotify-0.9
	>=dev-ruby/sass-3.3.13:* <dev-ruby/sass-3.5:*"

#ruby_add_bdepend "test? ( dev-ruby/colorize )"

all_ruby_prepare() {
	sed -i -e '/[Bb]undler/ s:^:#:' Rakefile || die

	# Remove rb-fsevent dependency since it is not needed on Linux and
	# not packaged.
	sed -i -e '/rb-fsevent/,/^-/ s:^:#:' ../metadata || die
}
