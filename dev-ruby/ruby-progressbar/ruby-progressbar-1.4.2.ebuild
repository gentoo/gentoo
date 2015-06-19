# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-progressbar/ruby-progressbar-1.4.2.ebuild,v 1.9 2015/02/05 10:23:14 ago Exp $

EAPI=5

USE_RUBY="ruby19 ruby20"

RUBY_FAKEGEM_RECIPE_TEST="rspec"
RUBY_FAKEGEM_TASK_DOC=""

RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="A Text Progress Bar Library for Ruby"
HOMEPAGE="https://github.com/jfelchner/ruby-progressbar"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 hppa ppc ppc64 x86 ~x86-fbsd"

IUSE="test"

ruby_add_bdepend "test? ( dev-ruby/timecop )"

all_ruby_prepare() {
	sed -i -e '/[Ss]imple[Cc]ov/ s:^:#:' spec/spec_helper.rb || die
}
