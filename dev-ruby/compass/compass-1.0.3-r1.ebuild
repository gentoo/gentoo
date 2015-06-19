# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/compass/compass-1.0.3-r1.ebuild,v 1.1 2015/02/13 10:23:01 graaff Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21"

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
	>=dev-ruby/sass-3.3.13 <dev-ruby/sass-3.5
	!!<dev-ruby/compass-0.12.7-r1"

#ruby_add_bdepend "test? ( dev-ruby/colorize )"

all_ruby_prepare() {
	sed -i -e '/[Bb]undler/ s:^:#:' Rakefile || die

	# Remove rb-fsevent dependency since it is not needed on Linux and
	# not packaged.
	sed -i -e '/rb-fsevent/,/^-/ s:^:#:' ../metadata || die
}
