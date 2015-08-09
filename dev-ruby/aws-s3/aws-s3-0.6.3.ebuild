# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="README"

# there is a stupid setup.rb in the bin/ directory so do not use the
# default.
RUBY_FAKEGEM_BINWRAP="s3sh"

inherit ruby-fakegem

DESCRIPTION="Client library for Amazon's Simple Storage Service's REST API"
HOMEPAGE="http://amazon.rubyforge.org/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

ruby_add_rdepend "dev-ruby/xml-simple
				dev-ruby/builder
				dev-ruby/mime-types
				virtual/ruby-ssl"
ruby_add_bdepend "test? ( dev-ruby/flexmock )"

RUBY_PATCHES=(
	${P}+ruby19.patch
)

each_ruby_test() {
	${RUBY} -I. -e "Dir['test/*_test.rb'].each {|f| require f }" || die
}
