# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/addressable/addressable-2.3.7.ebuild,v 1.1 2015/02/08 06:37:15 graaff Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_TASK_DOC="doc:yard"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RAKE_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="README.md CHANGELOG.md"

RUBY_FAKEGEM_EXTRAINSTALL="data"

inherit ruby-fakegem

DESCRIPTION="A replacement for the URI implementation that is part of Ruby's standard library"
HOMEPAGE="https://rubygems.org/gems/addressable https://github.com/sporkmonger/addressable"

LICENSE="Apache-2.0"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE="doc test"

ruby_add_bdepend "doc? ( dev-ruby/yard )"
ruby_add_bdepend "test? ( dev-ruby/rspec:2 )"

all_ruby_prepare() {
	# Remove spec-related tasks so that we don't need to require rspec
	# just to build the documentation, bug 383611.
	sed -i -e '/spectask/d' Rakefile || die
	rm tasks/rspec.rake || die
	sed -i -e '/[Cc]overalls/d' spec/spec_helper.rb || die

	# Remove specs requiring network connectivity
	rm spec/addressable/net_http_compat_spec.rb || die
}
