# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_TASK_DOC="doc"
RAKE_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="History.txt README.rdoc"

RUBY_FAKEGEM_EXTRAINSTALL="version.txt"

inherit ruby-fakegem

DESCRIPTION="Flexible logging library for use in Ruby programs based on the design of Java's log4j library"
HOMEPAGE="http://rubygems.org/gems/logging"

LICENSE="MIT"

SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

ruby_add_rdepend ">=dev-ruby/little-plugger-1.1.3 >=dev-ruby/multi_json-1.3.6"

ruby_add_bdepend "dev-ruby/bones test? ( dev-ruby/flexmock )"
