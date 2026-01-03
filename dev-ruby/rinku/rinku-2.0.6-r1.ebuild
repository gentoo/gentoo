# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_EXTRADOC="README.markdown"

RUBY_FAKEGEM_EXTENSIONS=(ext/rinku/extconf.rb)

inherit ruby-fakegem

DESCRIPTION="A Ruby library that does autolinking"
HOMEPAGE="https://github.com/vmg/rinku"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64"

all_ruby_prepare() {
	sed -i -e '/bundler/ s:^:#:' test/autolink_test.rb || die
}

each_ruby_test() {
	MT_NO_PLUGINS=true ${RUBY} -Ilib test/autolink_test.rb || die
}
