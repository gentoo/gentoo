# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_TASK_TEST=""
RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README ChangeLog"

RUBY_FAKEGEM_EXTENSIONS=(ext/extconf.rb ext/utf8/extconf.rb)

RUBY_FAKEGEM_GEMSPEC="ruby-odbc.gemspec"

inherit ruby-fakegem

DESCRIPTION="RubyODBC - For accessing ODBC data sources from the Ruby language"
HOMEPAGE="http://www.ch-werner.de/rubyodbc/"
SRC_URI="http://www.ch-werner.de/rubyodbc/${P}.tar.gz"

LICENSE="|| ( GPL-2 Ruby-BSD )"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="test"

DEPEND="${DEPEND} >=dev-db/unixODBC-2.0.6"
RDEPEND="${RDEPEND} >=dev-db/unixODBC-2.0.6"

# tests require to have an ODBC service enabled, so we can't run them
# for now :(
RESTRICT=test

all_ruby_prepare() {
	# Make sure that it doesn't try to use the absolute-local path for
	# the extension as we'd be unable to run it properly otherwise.
	sed -i -e 's:\./odbc:odbc:' test/{,utf8/}test.rb || die

	# Since lib should not get installed avoid it entirely…
	mv lib contrib || die
}

all_ruby_install() {
	all_fakegem_install
	dodoc doc/*.html
}
