# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_RUBY="ruby20 ruby21 ruby22 ruby23"

RUBY_FAKEGEM_RECIPE_TEST="rspec"
RUBY_FAKEGEM_RECIPE_DOC="yard"
RUBY_FAKEGEM_EXTRADOC="ChangeLog.md README.md"

inherit ruby-fakegem

DESCRIPTION="Calculate the differences between two XML/HTML documents"
HOMEPAGE="https://github.com/postmodern/nokogiri-diff"
LICENSE="MIT"

KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
SLOT="0"
IUSE=""

ruby_add_rdepend ">=dev-ruby/nokogiri-1.5 >=dev-ruby/tdiff-0.3.2"
