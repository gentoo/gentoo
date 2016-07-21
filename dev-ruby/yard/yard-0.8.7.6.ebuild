# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_RUBY="ruby20 ruby21 ruby22 ruby23"

RUBY_FAKEGEM_RECIPE_TEST="rspec"
RUBY_FAKEGEM_TASK_DOC="yard"

RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_DOCDIR="doc docs"

RUBY_FAKEGEM_EXTRAINSTALL="templates"

inherit ruby-fakegem

DESCRIPTION="Documentation generation tool for the Ruby programming language"
HOMEPAGE="http://yardoc.org/"

# The gem lakes the gemspec file needed to pass tests.
SRC_URI="https://github.com/lsegal/yard/archive/v${PV}.tar.gz -> ${P}-git.tgz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

ruby_add_bdepend "doc? ( || ( dev-ruby/maruku dev-ruby/rdiscount dev-ruby/bluecloth dev-ruby/kramdown ) )"

USE_RUBY="ruby20 ruby21" ruby_add_bdepend "test? ( >=dev-ruby/ruby-gettext-2.3.8 )"

all_ruby_prepare() {
	sed -i -e '/[Bb]undler/ s:^:#:' spec/spec_helper.rb || die

	# Avoid specs that make assumptions on load ordering that are not
	# true for us. This may be related to how we install in Gentoo. This
	# also drops a test requirement on dev-ruby/rack.
	rm -f spec/cli/server_spec.rb || die
}

each_ruby_prepare() {
	case ${RUBY} in
		*ruby23)
			# Avoid possible brittle test
			# https://github.com/lsegal/yard/issues/927
			sed -i -e '/should find lone comments/,/^    end/ s:^:#:' spec/parser/ruby/ruby_parser_spec.rb || die
			;;
	esac
}
