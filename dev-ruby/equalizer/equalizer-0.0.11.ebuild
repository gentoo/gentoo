# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22"

RUBY_FAKEGEM_EXTRADOC="CONTRIBUTING.md README.md"
RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_RECIPE_TEST="rspec3"

inherit ruby-fakegem

DESCRIPTION="Module to define equality, equivalence and inspection methods"
HOMEPAGE="https://github.com/dkubb/equalizer"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

all_ruby_prepare() {
	sed -i -e "/devtools/d" spec/spec_helper.rb || die

	# Avoid a failing spec caused by memoizable 0.4.2, and we ignore it
	# there as well.
	rm spec/unit/equalizer/included_spec.rb || die
}
