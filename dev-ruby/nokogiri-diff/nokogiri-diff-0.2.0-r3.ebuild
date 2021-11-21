# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby26 ruby27"

RUBY_FAKEGEM_RECIPE_TEST="rspec"
RUBY_FAKEGEM_EXTRADOC="ChangeLog.md README.md"

inherit ruby-fakegem

DESCRIPTION="Calculate the differences between two XML/HTML documents"
HOMEPAGE="https://github.com/postmodern/nokogiri-diff"
LICENSE="MIT"

KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~x86 ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
SLOT="0"
IUSE=""

ruby_add_rdepend ">=dev-ruby/nokogiri-1.5 >=dev-ruby/tdiff-0.3.2"
